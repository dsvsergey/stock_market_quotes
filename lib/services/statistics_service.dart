import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'package:dartz/dartz.dart';
import '../models/quote.dart';
import '../models/statistics.dart';
import '../l10n/app_localizations.dart';
import '../services/database_service.dart';

class StatisticsFailure {
  final String message;
  StatisticsFailure(this.message);
}

class StatisticsService {
  final AppLocalizations l10n;
  final DatabaseService databaseService;

  StatisticsService(this.l10n, this.databaseService);

  Future<Either<StatisticsFailure, Statistics>> calculateStatistics(
      List<Quote> quotes) async {
    try {
      final stopwatch = Stopwatch()..start();

      if (quotes.isEmpty) {
        return left(StatisticsFailure(l10n.noDataError));
      }

      // Позначаємо котирування як використані в розрахунках
      await _markQuotesAsUsed(quotes);

      // Виконуємо розрахунки в ізоляті
      final statistics = await _calculateInIsolate(quotes);

      stopwatch.stop();

      final result = Statistics.create(
        mean: statistics.mean,
        standardDeviation: statistics.standardDeviation,
        mode: statistics.mode,
        median: statistics.median,
        lostQuotes: statistics.lostQuotes,
        calculationTime: stopwatch.elapsed,
      );

      // Зберігаємо результати
      await databaseService.saveStatistics(result);

      return right(result);
    } catch (e) {
      return left(StatisticsFailure('${l10n.calculationError}: $e'));
    }
  }

  Future<_StatisticsResult> _calculateInIsolate(List<Quote> quotes) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(
      _calculateStatisticsIsolate,
      _IsolateMessage(
        quotes: quotes,
        sendPort: receivePort.sendPort,
      ),
    );

    final result = await receivePort.first as _StatisticsResult;
    receivePort.close();
    return result;
  }

  static void _calculateStatisticsIsolate(_IsolateMessage message) {
    final quotes = message.quotes;
    final values = quotes.map((q) => q.value).toList()..sort();

    // Обчислюємо середнє
    final mean = values.reduce((a, b) => a + b) / values.length;

    // Обчислюємо стандартне відхилення
    final variance =
        values.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) /
            values.length;
    final standardDeviation = sqrt(variance);

    // Обчислюємо моду
    final mode = _calculateMode(values);

    // Обчислюємо медіану
    final median = _calculateMedian(values);

    // Обчислюємо кількість втрачених котирувань
    final lostQuotes = _calculateLostQuotes(quotes);

    message.sendPort.send(_StatisticsResult(
      mean: mean,
      standardDeviation: standardDeviation,
      mode: mode,
      median: median,
      lostQuotes: lostQuotes,
    ));
  }

  Future<void> _markQuotesAsUsed(List<Quote> quotes) async {
    for (final quote in quotes) {
      quote.usedInCalculation = true;
      await databaseService.updateQuote(quote);
    }
  }

  static double _calculateMode(List<double> values) {
    if (values.isEmpty) return 0;

    var mode = values[0];
    var maxCount = 1;
    var currentValue = values[0];
    var currentCount = 1;

    for (var i = 1; i < values.length; i++) {
      if (values[i] == currentValue) {
        currentCount++;
      } else {
        if (currentCount > maxCount) {
          maxCount = currentCount;
          mode = currentValue;
        }
        currentValue = values[i];
        currentCount = 1;
      }
    }

    // Перевіряємо останню групу
    if (currentCount > maxCount) {
      mode = currentValue;
    }

    return mode;
  }

  static double _calculateMedian(List<double> values) {
    if (values.isEmpty) return 0;

    final middle = values.length ~/ 2;
    if (values.length % 2 == 1) {
      return values[middle];
    } else {
      return (values[middle - 1] + values[middle]) / 2;
    }
  }

  static int _calculateLostQuotes(List<Quote> quotes) {
    if (quotes.isEmpty) return 0;

    // Сортуємо за ID
    final sortedQuotes = List<Quote>.from(quotes)
      ..sort((a, b) => a.quoteId.compareTo(b.quoteId));

    var lostCount = 0;
    for (var i = 1; i < sortedQuotes.length; i++) {
      final expectedId = sortedQuotes[i - 1].quoteId + 1;
      final actualId = sortedQuotes[i].quoteId;
      if (actualId > expectedId) {
        lostCount += actualId - expectedId;
      }
    }

    return lostCount;
  }
}

class _IsolateMessage {
  final List<Quote> quotes;
  final SendPort sendPort;

  _IsolateMessage({
    required this.quotes,
    required this.sendPort,
  });
}

class _StatisticsResult {
  final double mean;
  final double standardDeviation;
  final double mode;
  final double median;
  final int lostQuotes;

  _StatisticsResult({
    required this.mean,
    required this.standardDeviation,
    required this.mode,
    required this.median,
    required this.lostQuotes,
  });
}

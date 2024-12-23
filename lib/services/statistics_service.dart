import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:dartz/dartz.dart';

import '../l10n/app_localizations.dart';
import '../models/quote.dart';
import '../models/statistics.dart';
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

      final usedQuotes =
          quotes.map((q) => q..usedInCalculation = true).toList();
      await Future.wait(
        usedQuotes.map((q) => databaseService.updateQuote(q)),
      );

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

    final values = List<double>.from(quotes.map((q) => q.value));
    values.sort();

    var sum = 0.0;
    var squareSum = 0.0;
    var currentValue = values[0];
    var currentCount = 1;
    var maxCount = 1;
    var mode = values[0];

    for (var i = 1; i < values.length; i++) {
      final value = values[i];
      sum += value;
      squareSum += value * value;

      if (value == currentValue) {
        currentCount++;
        if (currentCount > maxCount) {
          maxCount = currentCount;
          mode = currentValue;
        }
      } else {
        currentValue = value;
        currentCount = 1;
      }
    }

    final mean = sum / values.length;
    final variance = (squareSum / values.length) - (mean * mean);
    final standardDeviation = sqrt(variance);

    final median = values.length.isOdd
        ? values[values.length ~/ 2]
        : (values[(values.length - 1) ~/ 2] + values[values.length ~/ 2]) / 2;

    var lostQuotes = 0;
    final sortedQuotes = List<Quote>.from(quotes)
      ..sort((a, b) => a.quoteId.compareTo(b.quoteId));

    for (var i = 1; i < sortedQuotes.length; i++) {
      final diff = sortedQuotes[i].quoteId - sortedQuotes[i - 1].quoteId - 1;
      if (diff > 0) lostQuotes += diff;
    }

    message.sendPort.send(_StatisticsResult(
      mean: mean,
      standardDeviation: standardDeviation,
      mode: mode,
      median: median,
      lostQuotes: lostQuotes,
    ));
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

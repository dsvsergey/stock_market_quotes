import 'dart:async';
import 'dart:math';
import 'package:dartz/dartz.dart';
import '../models/quote.dart';
import '../models/statistics.dart';
import '../l10n/app_localizations.dart';

class StatisticsFailure {
  final String message;
  StatisticsFailure(this.message);
}

class StatisticsService {
  final AppLocalizations l10n;

  StatisticsService(this.l10n);

  Future<Either<StatisticsFailure, Statistics>> calculateStatistics(
      List<Quote> quotes) async {
    try {
      final stopwatch = Stopwatch()..start();

      if (quotes.isEmpty) {
        return left(StatisticsFailure(l10n.noDataError));
      }

      // Отримуємо всі значення
      final values = quotes.map((q) => q.value).toList();

      // Сортуємо для обчислення медіани та моди
      values.sort();

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
      final median = values.length.isOdd
          ? values[values.length ~/ 2]
          : (values[values.length ~/ 2 - 1] + values[values.length ~/ 2]) / 2;

      // Обчислюємо кількість втрачених котирувань
      final lostQuotes = _calculateLostQuotes(quotes);

      stopwatch.stop();

      return right(Statistics(
        mean: mean,
        standardDeviation: standardDeviation,
        mode: mode,
        median: median,
        lostQuotes: lostQuotes,
        calculationTime: stopwatch.elapsed,
      ));
    } catch (e) {
      return left(StatisticsFailure('${l10n.statisticsError}: $e'));
    }
  }

  double _calculateMode(List<double> sortedValues) {
    if (sortedValues.isEmpty) return 0;

    var maxCount = 0;
    var currentCount = 1;
    var mode = sortedValues[0];
    var currentValue = sortedValues[0];

    for (var i = 1; i < sortedValues.length; i++) {
      if (sortedValues[i] == currentValue) {
        currentCount++;
      } else {
        if (currentCount > maxCount) {
          maxCount = currentCount;
          mode = currentValue;
        }
        currentCount = 1;
        currentValue = sortedValues[i];
      }
    }

    // Перевіряємо останню групу
    if (currentCount > maxCount) {
      mode = currentValue;
    }

    return mode;
  }

  int _calculateLostQuotes(List<Quote> quotes) {
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

import 'dart:async';

import 'package:dartz/dartz.dart';

import '../l10n/app_localizations.dart';
import '../models/statistics.dart';
import 'database_service.dart';
import 'websocket_service.dart';

class StatisticsFailure {
  final String message;
  StatisticsFailure(this.message);
}

class StatisticsService {
  final AppLocalizations l10n;
  final DatabaseService databaseService;
  final WebSocketService websocketService;

  StatisticsService(this.l10n, this.databaseService, this.websocketService);

  Future<Either<StatisticsFailure, Statistics>> calculateStatistics() async {
    try {
      final stopwatch = Stopwatch()..start();

      final stats = websocketService.statistics;
      if (stats.count == 0) {
        return left(StatisticsFailure(l10n.noDataError));
      }

      stopwatch.stop();

      final result = Statistics.create(
        mean: stats.mean,
        standardDeviation: stats.standardDeviation,
        mode: stats.mode,
        median: stats.median,
        lostQuotes: stats.lostQuotes,
        calculationTime: stopwatch.elapsed,
      );

      await databaseService.saveStatistics(result);

      return right(result);
    } catch (e) {
      return left(StatisticsFailure('${l10n.calculationError}: $e'));
    }
  }
}

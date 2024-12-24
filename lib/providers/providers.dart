import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/quote.dart';
import '../models/statistics.dart';
import '../services/database_service.dart';
import '../services/statistics_service.dart';
import '../services/websocket_service.dart';

enum WebSocketState { disconnected, connecting, receiving }

// Провайдер для локалізації
final localizationProvider = Provider<AppLocalizations>((ref) {
  throw UnimplementedError('Needs to be overridden in the widget tree');
});

// База даних
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  final l10n = ref.watch(localizationProvider);
  return DatabaseService(l10n);
}, dependencies: [localizationProvider]);

// WebSocket сервіс
final websocketServiceProvider = Provider<WebSocketService>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  final l10n = ref.watch(localizationProvider);
  final service = WebSocketService(databaseService, l10n);
  ref.onDispose(() {
    service.dispose();
  });
  return service;
}, dependencies: [databaseServiceProvider, localizationProvider]);

// Стан підключення WebSocket
final connectionStateProvider =
    StateProvider<WebSocketState>((ref) => WebSocketState.disconnected);

// Стан ізоляту WebSocket
final websocketIsolateProvider = StreamProvider<bool>((ref) {
  final websocketService = ref.watch(websocketServiceProvider);
  return websocketService.isolateStream;
}, dependencies: [websocketServiceProvider]);

// Стрім котирувань
final quoteStreamProvider = StreamProvider<Quote>((ref) {
  final websocketService = ref.watch(websocketServiceProvider);
  return websocketService.quoteStream;
}, dependencies: [websocketServiceProvider]);

// Останні N котирувань
final lastQuotesProvider =
    StreamProvider.family<List<Quote>, int>((ref, count) async* {
  final databaseService = ref.watch(databaseServiceProvider);
  await for (final quotes in databaseService.watchQuotes()) {
    yield quotes.take(count).toList();
  }
}, dependencies: [databaseServiceProvider]);

// Сервіс статистики
final statisticsServiceProvider = Provider<StatisticsService>((ref) {
  final l10n = ref.watch(localizationProvider);
  final databaseService = ref.watch(databaseServiceProvider);
  final websocketService = ref.watch(websocketServiceProvider);
  return StatisticsService(l10n, databaseService, websocketService);
}, dependencies: [
  localizationProvider,
  databaseServiceProvider,
  websocketServiceProvider
]);

// Контроль оновлення статистики
final statisticsUpdateProvider = StateProvider<int>((ref) => 0);

// Провайдер статистики
final statisticsProvider = FutureProvider<Statistics?>((ref) async {
  final statisticsService = ref.watch(statisticsServiceProvider);
  final _ = ref.watch(statisticsUpdateProvider);
  final startTime = ref.watch(startTimeProvider);

  if (startTime == null) return null;

  final result = await statisticsService.calculateStatistics();
  return result.fold(
    (failure) => null,
    (statistics) => statistics,
  );
}, dependencies: [
  statisticsServiceProvider,
  statisticsUpdateProvider,
  startTimeProvider
]);

// Час старту
final startTimeProvider = StateProvider<DateTime?>((ref) => null);

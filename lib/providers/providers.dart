import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quote.dart';
import '../models/statistics.dart';
import '../services/database_service.dart';
import '../services/websocket_service.dart';
import '../services/statistics_service.dart';
import '../l10n/app_localizations.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  final l10n = ref.watch(localizationProvider);
  return DatabaseService(l10n);
});

final websocketServiceProvider = Provider<WebSocketService>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  final l10n = ref.watch(localizationProvider);
  final service = WebSocketService(databaseService, l10n);
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});

final websocketConnectionProvider = StateProvider<bool>((ref) => false);

final quoteStreamProvider = StreamProvider<Quote>((ref) {
  final websocketService = ref.watch(websocketServiceProvider);
  return websocketService.quoteStream;
});

// Провайдер для отримання всіх котирувань з бази даних
final allQuotesProvider = StreamProvider<List<Quote>>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  return databaseService.watchQuotes();
});

// Провайдер для отримання останніх N котирувань
final lastQuotesProvider =
    StreamProvider.family<List<Quote>, int>((ref, count) async* {
  final databaseService = ref.watch(databaseServiceProvider);
  await for (final quotes in databaseService.watchQuotes()) {
    yield quotes.take(count).toList();
  }
});

final statisticsServiceProvider = Provider<StatisticsService>((ref) {
  return StatisticsService(ref.watch(localizationProvider));
});

// Провайдер для контролю оновлення статистики
final statisticsUpdateProvider = StateProvider<int>((ref) => 0);

// Оновлюємо statisticsProvider щоб він реагував на зміни statisticsUpdateProvider
final statisticsProvider = FutureProvider<Statistics>((ref) async {
  // Спостерігаємо за оновленнями
  ref.watch(statisticsUpdateProvider);
  // Додаємо спостереження за новими котируваннями
  ref.watch(quoteStreamProvider);

  final quotes = await ref.watch(allQuotesProvider.future);
  final statisticsService = ref.watch(statisticsServiceProvider);

  final result = await statisticsService.calculateStatistics(quotes);
  return result.fold(
    (failure) => throw failure,
    (statistics) => statistics,
  );
});

// Додамо провайдер для локалізації
final localizationProvider = Provider<AppLocalizations>((ref) {
  throw UnimplementedError('Needs to be overridden in the widget tree');
});

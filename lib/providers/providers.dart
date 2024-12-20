import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quote.dart';
import '../services/database_service.dart';
import '../services/websocket_service.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

final websocketServiceProvider = Provider<WebSocketService>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  final service = WebSocketService(databaseService);
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quote.dart';
import '../services/database_service.dart';
import '../services/websocket_service.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

final websocketServiceProvider = Provider<WebSocketService>((ref) {
  final service = WebSocketService();
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

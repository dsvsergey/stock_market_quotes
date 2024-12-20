import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:dartz/dartz.dart';
import '../models/quote.dart';
import 'database_service.dart';

class WebSocketFailure {
  final String message;
  WebSocketFailure(this.message);
}

class WebSocketService {
  WebSocketChannel? _channel;
  final _quoteController = StreamController<Quote>.broadcast();
  final DatabaseService _databaseService;

  WebSocketService(this._databaseService);

  bool get isConnected => _channel != null;
  Stream<Quote> get quoteStream => _quoteController.stream;

  Future<Either<WebSocketFailure, Unit>> connect() async {
    try {
      if (_channel != null) {
        await disconnect();
      }

      _channel = WebSocketChannel.connect(
        Uri.parse('wss://trade.termplat.com:8800/?password=1234'),
      );

      _channel!.stream.listen(
        (data) async {
          try {
            final json = jsonDecode(data);
            final quote = Quote(
              quoteId: json['id'],
              value: json['value'].toDouble(),
              timestamp: DateTime.now(),
            );

            // Зберігаємо котирування в базу даних
            final result = await _databaseService.saveQuote(quote);
            result.fold(
              (failure) => print('Помилка збереження: ${failure.message}'),
              (_) => _quoteController.add(quote),
            );
          } catch (e) {
            print('Помилка парсингу даних: $e');
          }
        },
        onError: (error) {
          print('Помилка WebSocket: $error');
          disconnect();
        },
        onDone: () {
          print('WebSocket з\'єднання закрито');
          disconnect();
        },
      );

      return right(unit);
    } catch (e) {
      return left(WebSocketFailure('Помилка підключення до WebSocket: $e'));
    }
  }

  Future<void> disconnect() async {
    await _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    disconnect();
    _quoteController.close();
  }
}

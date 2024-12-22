import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import '../models/quote.dart';
import 'database_service.dart';
import '../l10n/app_localizations.dart';

class WebSocketFailure {
  final String message;
  final dynamic error;
  WebSocketFailure(this.message, [this.error]);
}

class WebSocketService {
  Socket? _socket;
  final _quoteController = StreamController<Quote>.broadcast();
  final _connectionStatusController = StreamController<bool>.broadcast();
  final DatabaseService _databaseService;
  final AppLocalizations l10n;
  bool _isConnected = false;
  Timer? _reconnectTimer;
  Timer? _pingTimer;
  static const _reconnectDelay = Duration(seconds: 5);
  static const _pingInterval = Duration(seconds: 30);

  WebSocketService(this._databaseService, this.l10n);

  bool get isConnected => _isConnected;
  Stream<Quote> get quoteStream => _quoteController.stream;
  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  Future<Either<WebSocketFailure, Unit>> connect() async {
    try {
      log(l10n.creatingConnection);

      _socket = await SecureSocket.connect(
        'trade.termplat.com',
        8800,
        onBadCertificate: (_) => true,
        timeout: const Duration(seconds: 30),
      );

      log(l10n.socketConnected);

      final key = base64.encode(List<int>.generate(
          16, (_) => DateTime.now().microsecondsSinceEpoch % 256));

      final handshake = 'GET /?password=1234 HTTP/1.1\r\n'
          'Host: trade.termplat.com:8800\r\n'
          'Connection: Upgrade\r\n'
          'Pragma: no-cache\r\n'
          'Cache-Control: no-cache\r\n'
          'User-Agent: Python/3.10 websockets/14.1\r\n'
          'Upgrade: websocket\r\n'
          'Origin: https://trade.termplat.com\r\n'
          'Sec-WebSocket-Version: 13\r\n'
          'Accept-Encoding: gzip, deflate\r\n'
          'Accept-Language: en-US,en;q=0.9\r\n'
          'Sec-WebSocket-Key: $key\r\n'
          'Sec-WebSocket-Extensions: permessage-deflate; client_max_window_bits\r\n\r\n';

      log('${l10n.sendingHandshake}:\n$handshake');
      _socket?.write(handshake);

      _socket?.listen(
        (List<int> data) {
          if (!_isConnected) {
            final response = String.fromCharCodes(data);
            if (response.contains('HTTP/1.1 101')) {
              log(l10n.connectionEstablished);
              _isConnected = true;
              _connectionStatusController.add(true);
              _startPingTimer();
            } else {
              log('${l10n.unexpectedResponse}:\n$response');
              _handleDisconnect();
              return;
            }
          } else {
            _handleMessage(data);
          }
        },
        onError: (error, stackTrace) {
          log(
            '${l10n.socketError}: $error',
            error: error,
            stackTrace: stackTrace,
          );
          _handleDisconnect();
        },
        onDone: () {
          log(l10n.connectionClosedMessage);
          _handleDisconnect();
        },
      );

      return right(unit);
    } catch (e, stackTrace) {
      log(
        l10n.connectionError,
        error: e,
        stackTrace: stackTrace,
      );
      return left(WebSocketFailure('${l10n.connectionError}: $e', e));
    }
  }

  void _handleMessage(List<int> data) {
    if (data.isEmpty) return;

    // Перший байт - FIN і опкод
    final byte1 = data[0];
    final fin = (byte1 & 0x80) != 0;
    final opcode = byte1 & 0x0F;

    // Другий байт - маска і довжина
    final byte2 = data[1];
    final masked = (byte2 & 0x80) != 0;
    var length = byte2 & 0x7F;

    var offset = 2;
    if (length == 126) {
      length = ((data[2] << 8) | data[3]);
      offset = 4;
    } else if (length == 127) {
      length = 0;
      for (var i = 0; i < 8; i++) {
        length = (length << 8) | data[2 + i];
      }
      offset = 10;
    }

    List<int>? maskingKey;
    if (masked) {
      maskingKey = data.sublist(offset, offset + 4);
      offset += 4;
    }

    final payload = data.sublist(offset, offset + length);
    if (masked) {
      for (var i = 0; i < payload.length; i++) {
        payload[i] = payload[i] ^ maskingKey![i % 4];
      }
    }

    if (opcode == 1) { // Текстовий фрейм
      final message = utf8.decode(payload);
      log('${l10n.receivedMessage}: $message');

      try {
        final json = jsonDecode(message);
        final quote = Quote(
          quoteId: int.parse(json['id'].toString()),
          value: double.parse(json['value'].toString()),
          timestamp: DateTime.now(),
        );

        _databaseService.saveQuote(quote).then(
          (result) => result.fold(
            (failure) => log('${l10n.saveError}: ${failure.message}'),
            (_) => _quoteController.add(quote),
          ),
        );
      } catch (e, stackTrace) {
        log(
          '${l10n.parsingDataError}: $e',
          error: e,
          stackTrace: stackTrace,
        );
      }
    }
  }

  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(_pingInterval, (timer) {
      if (_socket != null && _isConnected) {
        try {
          _socket?.write('ping');
        } catch (e) {
          log('${l10n.pingError}: $e');
          _handleDisconnect();
        }
      }
    });
  }

  void _handleDisconnect() {
    _isConnected = false;
    _connectionStatusController.add(false);
    _socket?.destroy();
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();

    _reconnectTimer = Timer(_reconnectDelay, () {
      if (!_isConnected) {
        connect();
      }
    });
  }

  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();
    _socket?.destroy();
    _isConnected = false;
    _connectionStatusController.add(false);
    log(l10n.connectionClosed);
  }

  void dispose() {
    disconnect();
    _quoteController.close();
    _connectionStatusController.close();
  }
}

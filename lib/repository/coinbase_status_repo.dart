import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:websockets_coins/api/coinbase_web_socket.dart';

final coinbaseStatusRepoProvider =
    AutoDisposeStreamProvider<Map<String, dynamic>>((ref) {
  final coinbaseWebSocket = ref.watch(coinbaseWebSocketProvider);
  final coinbaseStatusRepo = CoinbaseStatusRepo(coinbaseWebSocket);

  ref.onDispose(() {
    coinbaseStatusRepo._unSubscribeToStatus();
    coinbaseStatusRepo.dispose();
    ref.invalidate(coinbaseWebSocketProvider);
    debugPrint("CoinbaseStatusRepo disposed");
  });
  ref.onCancel(() {
    debugPrint("CoinbaseStatusRepo cancelled");
  });
  ref.onResume(() {
    debugPrint("CoinbaseStatusRepo resumed");
  });
  ref.onAddListener(() {
    debugPrint("CoinbaseStatusRepo added");
  });
  ref.onRemoveListener(() {
    debugPrint("CoinbaseStatusRepo removed");
  });

  return coinbaseStatusRepo.stream;
});

class CoinbaseStatusRepo {
  final CoinbaseWebSocket _coinbaseWebSocket;

  CoinbaseStatusRepo(this._coinbaseWebSocket) {
    _init();
  }

  WebSocketChannel? _channel;
  bool _isDisposed = false;
  bool _isSubscribed = false;
  final StreamController<Map<String, dynamic>> _streamController =
      StreamController<Map<String, dynamic>>();

  Stream<Map<String, dynamic>> get stream => _streamController.stream;

  void _init() {
    _channel = _coinbaseWebSocket.connect();
    _subscribeToStatus();
    _listenToStatus();
  }

  void _subscribeToStatus() {
    if (_isDisposed) return;

    final message = jsonEncode({
      "type": "subscribe",
      "channels": [
        {"name": "status"}
      ]
    });

    _isSubscribed = true;
    _channel?.sink.add(message);
  }

  void _unSubscribeToStatus() {
    if (_isDisposed) return;

    final message = jsonEncode({
      "type": "unsubscribe",
      "channels": [
        {"name": "status"}
      ]
    });

    _isSubscribed = false;
    _channel?.sink.add(message);
  }

  void _listenToStatus() {
    if (_isDisposed) return;

    _channel?.stream.listen(
      (data) {
        final jsonData = jsonDecode(data) as Map<String, dynamic>;
        _streamController.add(jsonData);
      },
      onDone: () {},
      onError: (error) {
        debugPrint(error.toString());
        _reconnect();
      },
    );
  }

  void _reconnect() {
    if (_isDisposed) return;
    Future.delayed(Duration(seconds: 3), () {
      _init();
    });
  }

  void dispose() {
    _isDisposed = true;
    _channel?.sink.close();
    _streamController.close();
  }
}

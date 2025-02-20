import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:websockets_coins/constant/constant.dart';

final coinbaseWebSocketProvider =
    Provider.autoDispose<CoinbaseWebSocket>((ref) {
  ref.onDispose(() {
    debugPrint("Coinbase WebSocket disposed");
  });
  ref.onCancel(() {
    debugPrint("Coinbase WebSocket cancelled");
  });
  ref.onResume(() {
    debugPrint("Coinbase WebSocket resumed");
  });
  ref.onAddListener(() {
    debugPrint("Coinbase WebSocket added");
  });
  ref.onRemoveListener(() {
    debugPrint("Coinbase WebSocket removed");
  });

  return CoinbaseWebSocket();
});

class CoinbaseWebSocket {
  CoinbaseWebSocket() {
    debugPrint("Coinbase WebSocket initialized");
  }

  WebSocketChannel connect() {
    return WebSocketChannel.connect(Uri.parse(Constant.coinbaseUrl));
  }
}

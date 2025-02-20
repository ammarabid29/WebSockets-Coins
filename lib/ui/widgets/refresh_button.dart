import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:websockets_coins/view_model/coin_status_view_model.dart';

class RefreshButton extends ConsumerWidget {
  const RefreshButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        ref.read(coinStatusViewModelProvider.notifier).reset();
      },
      icon: Icon(Icons.refresh),
    );
  }
}

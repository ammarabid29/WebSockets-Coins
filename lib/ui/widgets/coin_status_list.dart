import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:websockets_coins/view_model/coin_status_view_model.dart';

class CoinStatusList extends ConsumerWidget {
  const CoinStatusList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue =
        ref.watch(coinStatusViewModelProvider.select((state) => state.data));

    return asyncValue.when(
      data: (data) {
        final coins = data["products"] as List<dynamic>;
        return ListView.builder(
          itemCount: coins.length,
          itemBuilder: (context, index) {
            final coin = coins[index] as Map<String, dynamic>;
            return ListTile(
              title: Text(coin["id"] as String),
              subtitle: Text(coin["status"] as String),
            );
          },
        );
      },
      error: (error, stacktrace) {
        return Center(
          child: Text(error.toString()),
        );
      },
      loading: () {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

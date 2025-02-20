import 'package:flutter/material.dart';
import 'package:websockets_coins/ui/widgets/coin_status_list.dart';
import 'package:websockets_coins/ui/widgets/refresh_button.dart';

class CoinStatusScreen extends StatefulWidget {
  const CoinStatusScreen({super.key});

  @override
  State<CoinStatusScreen> createState() => _CoinStatusScreenState();
}

class _CoinStatusScreenState extends State<CoinStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Coin Status"),
        actions: [
          RefreshButton(),
        ],
      ),
      body: CoinStatusList(),
    );
  }
}

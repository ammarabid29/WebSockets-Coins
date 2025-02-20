import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:websockets_coins/repository/coinbase_status_repo.dart';
import 'package:websockets_coins/state/coin_status_state.dart';

final coinStatusViewModelProvider =
    AutoDisposeNotifierProvider<CoinStatusViewModel, CoinStatusState>(
        CoinStatusViewModel.new);

class CoinStatusViewModel extends AutoDisposeNotifier<CoinStatusState> {
  @override
  CoinStatusState build() {
    final data = ref.watch(coinbaseStatusRepoProvider);
    return CoinStatusState(data: data);
  }

  void reset() {
    ref.invalidate(coinbaseStatusRepoProvider);
  }
}

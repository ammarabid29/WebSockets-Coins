import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coin_status_state.freezed.dart';

@freezed
class CoinStatusState with _$CoinStatusState {
  const factory CoinStatusState({
    @Default(AsyncLoading()) AsyncValue<Map<String, dynamic>> data,
  }) = _CoinStatusState;
}

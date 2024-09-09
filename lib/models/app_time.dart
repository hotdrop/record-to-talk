import 'package:flutter_riverpod/flutter_riverpod.dart';

final appTimeManagerProvider = NotifierProvider<AppTimeNotifier, AppTime>(AppTimeNotifier.new);

class AppTimeNotifier extends Notifier<AppTime> {
  @override
  AppTime build() {
    return AppTime.init();
  }

  void updateInputToTextTime(int epoch) {
    state = state.copyWith(currentInputToTextTimeEpoch: epoch);
  }

  void updateOwnOutToTextTime(int epoch) {
    state = state.copyWith(currentOwnOutToTextTimeEpoch: epoch);
  }

  void updateSummaryTime(int epoch) {
    state = state.copyWith(currentSummaryTimeEpoch: epoch);
  }
}

class AppTime {
  const AppTime._(this.currentInputToTextTimeEpoch, this.currentOwnOutToTextTimeEpoch, this.currentSummaryTimeEpoch);

  factory AppTime.init() {
    return const AppTime._(0, 0, 0);
  }

  final int currentInputToTextTimeEpoch;
  final int currentOwnOutToTextTimeEpoch;
  final int currentSummaryTimeEpoch;

  AppTime copyWith({int? currentInputToTextTimeEpoch, int? currentOwnOutToTextTimeEpoch, int? currentSummaryTimeEpoch}) {
    return AppTime._(
      currentInputToTextTimeEpoch ?? this.currentInputToTextTimeEpoch,
      currentOwnOutToTextTimeEpoch ?? this.currentOwnOutToTextTimeEpoch,
      currentSummaryTimeEpoch ?? this.currentSummaryTimeEpoch,
    );
  }
}

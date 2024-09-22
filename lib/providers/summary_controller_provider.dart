import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record_to_talk/models/record_to_text.dart';
import 'package:record_to_talk/models/result.dart';
import 'package:record_to_talk/providers/record_controller_provider.dart';
import 'package:record_to_talk/repository/gpt_repository.dart';

final summaryControllerProvider = AsyncNotifierProvider<SummaryControllerNotifier, SummaryTextResult?>(SummaryControllerNotifier.new);

class SummaryControllerNotifier extends AsyncNotifier<SummaryTextResult?> {
  @override
  FutureOr<SummaryTextResult?> build() async {
    final record = ref.watch(recordControllerProvider);
    final recordItems = ref.watch(recordToTextsProvider);

    // データがない場合はサマリー実行しない
    if (recordItems.isEmpty) {
      return null;
    }

    // 文字起こし中の場合はサマリー実行しない
    if (record.isWait()) {
      return state.value;
    }

    // エラーが発生している場合はサマリー実行しない
    if (record.isError()) {
      return null;
    }

    // TODO inとoutを単純に繋げた会話だとおかしくなるので、どちらが話しているか？という情報を付与した方が良いか？
    final mergeText = recordItems.map((e) => e.speechToText).join('');
    return await ref.read(gptRepositoryProvider).requestSummary(mergeText);
  }

  Future<void> retry() async {
    final record = ref.read(recordControllerProvider);

    if (record.isWait()) {
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final recordItems = ref.read(recordToTextsProvider);
      final targetText = recordItems.map((e) => e.speechToText).join('');
      return await ref.read(gptRepositoryProvider).requestSummary(targetText);
    });
  }
}

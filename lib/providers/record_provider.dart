import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record_to_talk/models/record.dart';
import 'package:record_to_talk/models/result.dart';
import 'package:record_to_talk/providers/record_items_provider.dart';
import 'package:record_to_talk/providers/summary_controller_provider.dart';

final currentRecordProvider = NotifierProvider<_RecordNotifier, Record?>(_RecordNotifier.new);

class _RecordNotifier extends Notifier<Record?> {
  @override
  Record? build() {
    return null;
  }

  ///
  /// 録音データを選択状態にする
  ///
  Future<void> select(Record record) async {
    // 取得した履歴をそれぞれ録音データとサマリーデータにセットする。サマリーはAsyncNotifierProviderなのでawaitつけている
    ref.read(recordItemsProvider.notifier).setItems(record.recordItems);
    await ref.read(summaryControllerProvider.notifier).setSummaryTextResult(record.summaryTextResult);
    state = record;
  }

  ///
  /// 録音データを追加する
  ///
  Future<void> setRecordItem(RecordItem recordItem) async {
    if (state == null) {
      state = Record(recordItems: [recordItem]);
    } else {
      state = state!.setRecoreItem(recordItem);
    }
  }

  ///
  /// サマリーデータを保存する
  ///
  Future<void> setSummaryTextResult(SummaryTextResult result) async {
    if (state != null) {
      state = state!.copyWith(summaryTextResult: result);
    }
  }
}

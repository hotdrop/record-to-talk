import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record_to_talk/repository/gpt_repository.dart';
import 'package:uuid/uuid.dart';

final recordToTextsProvider = NotifierProvider<RecordToTextsNotifier, List<RecordToText>>(RecordToTextsNotifier.new);

class RecordToTextsNotifier extends Notifier<List<RecordToText>> {
  @override
  List<RecordToText> build() {
    return [];
  }

  Future<void> executeToText(String inFilePath, String outFilePath) async {
    // 音声をテキストに変換する。これは同時実行して後でawaitすれば良さそうだが
    final inResults = await ref.read(gptRepositoryProvider).recordToText(filePath: inFilePath);
    final outResults = await ref.read(gptRepositoryProvider).recordToText(filePath: outFilePath);

    final records = <RecordToText>[];
    for (var inRet in inResults) {
      records.add(InputRecordToText.create(text: inRet.text, timestamp: inRet.timestamp));
    }
    for (var outRet in outResults) {
      records.add(OwnOutRecordToText.create(text: outRet.text, timestamp: outRet.timestamp));
    }
    // タイムスタンプでソートする
    records.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    state = [...state, ...records];
  }
}

sealed class RecordToText {
  const RecordToText(this.id, this.speechToText, this.timestamp);
  final String id;
  final String speechToText;
  final DateTime timestamp;
}

class InputRecordToText extends RecordToText {
  InputRecordToText._(super.id, super.speechToText, super.timestamp);

  factory InputRecordToText.create({required String text, required DateTime timestamp}) {
    return InputRecordToText._(const Uuid().v4(), text, timestamp);
  }
}

class OwnOutRecordToText extends RecordToText {
  OwnOutRecordToText._(super.id, super.speechToText, super.timestamp);

  factory OwnOutRecordToText.create({required String text, required DateTime timestamp}) {
    return OwnOutRecordToText._(const Uuid().v4(), text, timestamp);
  }
}

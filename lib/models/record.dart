import 'package:path/path.dart' as path;
import 'package:record_to_talk/models/result.dart';

class Record {
  const Record({
    required this.recordItems,
    this.summaryTextResult,
  });

  // TODO INとOUT両方のリストを持ってこのクラスでマージするか、マージしたものを持つか
  final List<RecordItem> recordItems;
  final SummaryTextResult? summaryTextResult;

  Record setRecoreItem(RecordItem newRecordItem) {
    final idx = recordItems.indexWhere((e) => e.id == newRecordItem.id);
    if (idx != -1) {
      return copyWith(recordItems: List.of(recordItems)..[idx] = newRecordItem);
    } else {
      return copyWith(recordItems: [newRecordItem, ...recordItems]);
    }
  }

  Record copyWith({
    List<RecordItem>? recordItems,
    SummaryTextResult? summaryTextResult,
  }) {
    return Record(
      recordItems: recordItems ?? this.recordItems,
      summaryTextResult: summaryTextResult ?? this.summaryTextResult,
    );
  }
}

class RecordItem {
  const RecordItem({
    required this.id,
    required this.filePath,
    required this.recordTime,
    this.speechToText,
    this.speechToTextExecTime = 0,
    this.status = RecordToTextStatus.wait,
    this.errorMessage,
  });

  // TODO タイムスタンプが必要
  final String id;
  final String filePath;
  final int recordTime;
  final int speechToTextExecTime;

  final String? speechToText;
  final RecordToTextStatus status;
  final String? errorMessage;

  String fileName() => path.basename(filePath);

  bool isSuccess() => status == RecordToTextStatus.success;
  bool isError() => status == RecordToTextStatus.error;
  bool isWait() => status == RecordToTextStatus.wait;

  RecordItem copyWith({
    String? speechToText,
    int? speechToTextExecTime,
    RecordToTextStatus? status,
    String? errorMessage,
  }) {
    return RecordItem(
      id: id,
      filePath: filePath,
      recordTime: recordTime,
      speechToTextExecTime: speechToTextExecTime ?? this.speechToTextExecTime,
      speechToText: speechToText ?? this.speechToText,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

enum RecordToTextStatus { wait, success, error }

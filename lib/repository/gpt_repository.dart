import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record_to_talk/common/app_logger.dart';
import 'package:record_to_talk/common/int_extension.dart';
import 'package:record_to_talk/models/record_to_text.dart';
import 'package:record_to_talk/models/result.dart';
import 'package:record_to_talk/repository/remote/open_ai_api.dart';

final gptRepositoryProvider = Provider((ref) => GPTRepository(ref));

class GPTRepository {
  const GPTRepository(this.ref);

  final Ref ref;

  Future<List<RecordToTextResult>> recordToText({required String filePath}) async {
    // final results = await ref.read(openAiApiProvider).speechToText(filePath);
    final now = DateTime.now();
    final results = [
      RecordToTextResult('こんにちわ', now),
      RecordToTextResult('これはテストです', now),
    ];
    return results;
  }

  Future<SummaryTextResult> requestSummary(String text) async {
    final stopWatch = Stopwatch()..start();
    // final result = await ref.read(openAiApiProvider).requestSummary(text);
    final result = 'これはサマリーテストです';
    stopWatch.stop();
    return SummaryTextResult(result, stopWatch.elapsedMilliseconds);
  }
}

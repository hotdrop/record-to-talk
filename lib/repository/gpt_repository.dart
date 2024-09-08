import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record_to_talk/models/record.dart';
import 'package:record_to_talk/models/result.dart';
import 'package:record_to_talk/repository/remote/open_ai_api.dart';

final gptRepositoryProvider = Provider((ref) => GPTRepository(ref));

class GPTRepository {
  const GPTRepository(this.ref);

  final Ref ref;

  Future<RecordToTextResult> speechToText(RecordItem recordItem) async {
    final stopWatch = Stopwatch()..start();
    final text = await ref.read(openAiApiProvider).speechToText(recordItem);
    stopWatch.stop();
    return RecordToTextResult(text, stopWatch.elapsedMilliseconds);
  }

  Future<SummaryTextResult> requestSummary(String text) async {
    final stopWatch = Stopwatch()..start();
    final result = await ref.read(openAiApiProvider).requestSummary(text);
    stopWatch.stop();
    return SummaryTextResult(result, stopWatch.elapsedMilliseconds);
  }
}

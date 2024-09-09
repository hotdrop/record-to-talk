import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record_to_talk/models/app_time.dart';
import 'package:record_to_talk/models/record_to_text.dart';
import 'package:record_to_talk/repository/remote/open_ai_api.dart';

final gptRepositoryProvider = Provider((ref) => GPTRepository(ref));

class GPTRepository {
  const GPTRepository(this.ref);

  final Ref ref;

  Future<List<RecordToTextResult>> recordToText({required String filePath}) async {
    final stopWatch = Stopwatch()..start();
    final results = await ref.read(openAiApiProvider).speechToText(filePath);
    stopWatch.stop();
    ref.read(appTimeManagerProvider.notifier).updateInputToTextTime(stopWatch.elapsedMilliseconds);
    return results;
  }

  Future<String> requestSummary(String text) async {
    final stopWatch = Stopwatch()..start();
    final result = await ref.read(openAiApiProvider).requestSummary(text);
    stopWatch.stop();
    ref.read(appTimeManagerProvider.notifier).updateSummaryTime(stopWatch.elapsedMilliseconds);
    return result;
  }
}

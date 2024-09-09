import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record_to_talk/models/app_setting.dart';
import 'package:record_to_talk/models/record_to_text.dart';
import 'package:record_to_talk/providers/record_controller_provider.dart';
import 'package:record_to_talk/providers/summary_controller_provider.dart';
import 'package:record_to_talk/providers/timer_provider.dart';
import 'package:record_to_talk/ui/widgets/record_to_talk_view.dart';
import 'package:record_to_talk/ui/widgets/summary_text_view.dart';

class RecordContents extends StatelessWidget {
  const RecordContents({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Expanded(flex: 3, child: _TalkRecordView()),
            VerticalDivider(width: 1),
            Expanded(flex: 2, child: _SummaryTextView()),
          ],
        ),
      ),
    );
  }
}

class _TalkRecordView extends StatelessWidget {
  const _TalkRecordView();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _ViewTimer(),
        SizedBox(height: 16),
        _OperationButtons(),
        Divider(),
        _RecordToTextView(),
      ],
    );
  }
}

class _ViewTimer extends ConsumerWidget {
  const _ViewTimer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(timerProvider);
    final nowRecording = ref.watch(nowRecordingProvider);
    final color = nowRecording ? Colors.redAccent : Colors.green;

    return Column(
      children: [
        Text(nowRecording ? '録音中' : '停止', style: TextStyle(color: color, fontSize: 36)),
        Text('録音時間: $timer 秒', style: TextStyle(color: color)),
      ],
    );
  }
}

class _OperationButtons extends ConsumerWidget {
  const _OperationButtons();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowRecording = ref.watch(nowRecordingProvider);
    final apiKey = ref.watch(appSettingProvider.select((value) => value.apiKey));

    if (apiKey.isEmpty) {
      return const Text(
        'Settingメニューを開きApiKeyを設定してください。',
        style: TextStyle(color: Colors.red),
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 8,
      children: [
        ElevatedButton.icon(
          onPressed: !nowRecording ? () => ref.read(recordControllerProvider.notifier).start() : null,
          label: const Text('開始'),
          icon: Icon(Icons.fiber_manual_record_rounded, color: nowRecording ? null : Colors.red),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: nowRecording ? () => ref.read(recordControllerProvider.notifier).stop() : null,
          label: const Text('停止'),
          icon: const Icon(Icons.stop),
        ),
      ],
    );
  }
}

class _RecordToTextView extends ConsumerWidget {
  const _RecordToTextView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordToTexts = ref.watch(recordToTextsProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RecordToTextView(recordToTexts),
    );
  }
}

class _SummaryTextView extends ConsumerWidget {
  const _SummaryTextView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(summaryControllerProvider).when(
          data: (data) => SummayTextView(data),
          error: (e, s) => SummaryErrorTextView(
            errorMessage: 'エラーが発生しました\n$e',
            onPressed: () async {
              await ref.read(summaryControllerProvider.notifier).retry();
            },
          ),
          loading: () => const SummayLoadingView(),
        );
  }
}

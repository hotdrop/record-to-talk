import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record_to_talk/common/int_extension.dart';
import 'package:record_to_talk/models/app_time.dart';
import 'package:record_to_talk/ui/widgets/retry_button.dart';

class SummayTextView extends StatelessWidget {
  const SummayTextView(this.summary, {super.key});

  final String? summary;

  @override
  Widget build(BuildContext context) {
    final textLength = summary?.length ?? 0;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _Header(textLength: textLength),
          const Divider(),
          _TextViewArea(summary ?? '録音データが追加されるたびにここにまとめテキストが作成されます。'),
        ],
      ),
    );
  }
}

class SummayLoadingView extends StatelessWidget {
  const SummayLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          _Header(textLength: 0),
          Divider(),
          Text('これまでの文字起こしテキストからサマリーを作成します'),
          SizedBox(height: 64),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}

class SummaryErrorTextView extends StatelessWidget {
  const SummaryErrorTextView({super.key, required this.errorMessage, required this.onPressed});

  final String errorMessage;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const _Header(textLength: 0),
          const SizedBox(height: 8),
          const Divider(),
          RetryButton(onPressed: onPressed),
          _TextViewArea(errorMessage, textColor: Colors.red),
        ],
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.textLength});

  final int textLength;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final execTime = ref.watch(appTimeManagerProvider.select((v) => v.currentSummaryTimeEpoch));
    return Column(
      children: [
        const Text('これまでの録音情報まとめ', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (textLength > 0) Text('文字数: $textLength', style: const TextStyle(color: Colors.green)),
            if (execTime > 0) Text('実行時間: ${execTime.formatExecTime()}', style: const TextStyle(color: Colors.green)),
          ],
        ),
      ],
    );
  }
}

class _TextViewArea extends StatelessWidget {
  const _TextViewArea(this.text, {this.textColor});

  final String text;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        child: SelectableText(text, style: TextStyle(color: textColor)),
      ),
    );
  }
}

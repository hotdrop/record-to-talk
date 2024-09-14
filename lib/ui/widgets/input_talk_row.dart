import 'package:flutter/material.dart';
import 'package:record_to_talk/models/record_to_text.dart';

class InputTalkRow extends StatelessWidget {
  const InputTalkRow(this.recordToText, {super.key});

  final InputRecordToText recordToText;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 32),
        Expanded(
          child: Card(
            elevation: 1.0,
            color: Theme.of(context).colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SelectableText(recordToText.speechToText),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Icon(Icons.person_pin),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

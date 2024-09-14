import 'package:flutter/material.dart';
import 'package:record_to_talk/models/record_to_text.dart';

class OwnTalkRow extends StatelessWidget {
  const OwnTalkRow(this.recordToText, {super.key});

  final OwnOutRecordToText recordToText;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 8),
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Icon(Icons.person_pin),
        ),
        Expanded(
          child: Card(
            elevation: 1.0,
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SelectableText(recordToText.speechToText),
            ),
          ),
        ),
        const SizedBox(width: 32),
      ],
    );
  }
}

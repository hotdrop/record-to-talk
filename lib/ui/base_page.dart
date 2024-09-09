import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record_to_talk/providers/record_controller_provider.dart';
import 'package:record_to_talk/providers/select_menu_provider.dart';
import 'package:record_to_talk/ui/app_setting_contents.dart';
import 'package:record_to_talk/ui/record_contents.dart';

class BasePage extends ConsumerWidget {
  const BasePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectMenu = ref.watch(selectMenuProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            const Expanded(flex: 1, child: _MenuList()),
            const VerticalDivider(width: 1),
            Expanded(
              flex: 8,
              child: (selectMenu == 0) ? const RecordContents() : const AppSettingContents(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuList extends ConsumerWidget {
  const _MenuList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SelectMenu(
          icon: Icons.record_voice_over,
          label: '録音',
          onTap: () {
            final isRecording = ref.read(nowRecordingProvider);
            if (isRecording) {
              return;
            }
            ref.read(selectMenuProvider.notifier).selectRecordMenu();
          },
        ),
        const Divider(),
        const Spacer(),
        const Divider(),
        _SelectMenu(
          icon: Icons.settings,
          label: '設定',
          onTap: () => ref.read(selectMenuProvider.notifier).selectSettingMenu(),
        ),
      ],
    );
  }
}

class _SelectMenu extends ConsumerWidget {
  const _SelectMenu({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nowRecording = ref.watch(nowRecordingProvider);

    return InkWell(
      onTap: nowRecording ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Flexible(child: Text(label, style: TextStyle(color: nowRecording ? Colors.grey : null))),
          ],
        ),
      ),
    );
  }
}

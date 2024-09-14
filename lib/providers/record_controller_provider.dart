import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'package:record_to_talk/common/app_logger.dart';
import 'package:record_to_talk/models/app_setting.dart';
import 'package:record_to_talk/models/record_to_text.dart';
import 'package:record_to_talk/providers/timer_provider.dart';

final recordControllerProvider = NotifierProvider<RecordControllerNotifier, RecordController>(RecordControllerNotifier.new);

class RecordControllerNotifier extends Notifier<RecordController> {
  @override
  RecordController build() {
    ref.onDispose(() {
      state.dispose();
    });
    return RecordController(inputAudioRecorder: AudioRecorder(), ownOutAudioRecorder: AudioRecorder());
  }

  Future<void> start() async {
    try {
      if (await state.hasPermission()) {
        // 初回録音を実行し、以降は一定間隔で録音データを管理する
        ref.read(timerProvider.notifier).start();
        final appSetting = ref.read(appSettingProvider);
        await state.start(appSetting);
        await _startRecordingLoop();
      }
    } catch (e, s) {
      stop();
      AppLogger.e('録音処理でエラー', error: e, s: s);
      rethrow;
    }
  }

  Future<void> _startRecordingLoop() async {
    final appSetting = ref.read(appSettingProvider);
    Timer.periodic(Duration(seconds: appSetting.recordIntervalSeconds), (timer) async {
      // 現在のセグメントを保存し、音声データを生成
      await _saveCurrentSegment();
      // 新しいセグメントの録音を開始
      await state.start(appSetting);
    });

    ref.read(nowRecordingProvider.notifier).state = true;
  }

  Future<void> stop() async {
    await _saveCurrentSegment();
    ref.read(timerProvider.notifier).stop();
    ref.read(nowRecordingProvider.notifier).state = false;
  }

  Future<void> _saveCurrentSegment() async {
    final (inPath, outPath) = await state.stop();
    if (inPath == null || outPath == null) {
      state = state.copyWith(status: RecordToTalkStatus.error);
      AppLogger.e('音声データの保存に失敗しました inPath=$inPath outPath=$outPath');
      return;
    }

    try {
      await ref.read(recordToTextsProvider.notifier).executeToText(inPath, outPath);
      state = state.copyWith(status: RecordToTalkStatus.success);
    } catch (e) {
      state = state.copyWith(status: RecordToTalkStatus.error, errorMessage: '$e');
    }
  }
}

final recordDevicesProvider = FutureProvider<List<InputDevice>>((ref) async {
  return await ref.watch(recordControllerProvider).listInputDevices();
});

final nowRecordingProvider = StateProvider<bool>((ref) => false);

///
/// 録音状態や結果を保持するコントローラ
///
class RecordController {
  const RecordController({
    required this.inputAudioRecorder,
    required this.ownOutAudioRecorder,
    this.status = RecordToTalkStatus.none,
    this.toTextExecTime = 0,
    this.errorMessage,
  });

  final AudioRecorder inputAudioRecorder;
  final AudioRecorder ownOutAudioRecorder;
  final RecordToTalkStatus status;
  final int toTextExecTime;
  final String? errorMessage;

  bool isSuccess() => status == RecordToTalkStatus.success;
  bool isError() => status == RecordToTalkStatus.error;
  bool isWait() => status == RecordToTalkStatus.wait;

  Future<bool> hasPermission() async {
    return await inputAudioRecorder.hasPermission();
  }

  Future<void> start(AppSetting appSetting) async {
    final inputConfig = RecordConfig(encoder: AudioEncoder.aacLc, device: appSetting.inputDevice);
    final ownOutConfig = RecordConfig(encoder: AudioEncoder.aacLc, device: appSetting.ownOutDevice);

    await inputAudioRecorder.start(inputConfig, path: appSetting.createSoundFilePath(alias: 'in'));
    await ownOutAudioRecorder.start(ownOutConfig, path: appSetting.createSoundFilePath(alias: 'out'));
  }

  Future<(String?, String?)> stop() async {
    final inFilePath = await inputAudioRecorder.stop();
    final ownOutFilePath = await ownOutAudioRecorder.stop();
    return (inFilePath, ownOutFilePath);
  }

  Future<List<InputDevice>> listInputDevices() async {
    return await inputAudioRecorder.listInputDevices();
  }

  void dispose() {
    inputAudioRecorder.dispose();
    ownOutAudioRecorder.dispose();
  }

  RecordController copyWith({RecordToTalkStatus? status, int? toTextExecTime, String? errorMessage}) {
    return RecordController(
      inputAudioRecorder: inputAudioRecorder,
      ownOutAudioRecorder: ownOutAudioRecorder,
      status: status ?? this.status,
      toTextExecTime: toTextExecTime ?? this.toTextExecTime,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

enum RecordToTalkStatus { none, wait, success, error }

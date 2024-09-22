import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:record/record.dart';
import 'package:record_to_talk/repository/app_setting_repository.dart';

final appSettingProvider = NotifierProvider<AppSettingNotifier, AppSetting>(AppSettingNotifier.new);

class AppSettingNotifier extends Notifier<AppSetting> {
  @override
  AppSetting build() {
    return const AppSetting();
  }

  Future<void> refresh({
    required String cacheDirPath,
    int? recordIntervalSecond,
    String? summaryPrompt,
    required String appName,
    required String appVersion,
    required ThemeMode themeMode,
  }) async {
    state = state.copyWith(
      cacheDirPath: cacheDirPath,
      recordIntervalSeconds: recordIntervalSecond,
      summaryPrompt: summaryPrompt,
      appName: appName,
      appVersion: appVersion,
      themeMode: themeMode,
    );
  }

  void setApiKey(String value) {
    state = state.copyWith(apiKey: value);
  }

  void setRecordIntervalSecond(int value) {
    ref.read(appSettingsRepositoryProvider).saveRecordIntervalSeconds(value);
    state = state.copyWith(recordIntervalSeconds: value);
  }

  void setRecordDevice(InputDevice device) {
    state = state.copyWith(inputDevice: device);
  }

  void setOwnOutDevice(InputDevice device) {
    state = state.copyWith(ownOutDevice: device);
  }

  void setSummaryPrompt(String value) {
    ref.read(appSettingsRepositoryProvider).saveSummaryPrompt(value);
    state = state.copyWith(summaryPrompt: value);
  }

  Future<void> setDarkMode(bool isDarkMode) async {
    await ref.read(appSettingsRepositoryProvider).changeThemeMode(isDarkMode);
    final mode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    state = state.copyWith(themeMode: mode);
  }
}

class AppSetting {
  const AppSetting({
    this.apiKey = '',
    this.cacheDirPath = '',
    this.audioExtension = 'm4a', // 複数プラットフォーム対応する場合は拡張子を可変にする
    this.recordIntervalSeconds = 10,
    this.inputDevice,
    this.ownOutDevice,
    this.summaryPrompt = defaultSummaryPrompt,
    this.appName = '',
    this.appVersion = '',
    this.themeMode = ThemeMode.system,
  });

  // OpenAI API Key
  final String apiKey;
  // 一時出力する音声データファイルのディレクトリパス
  final String cacheDirPath;
  // 一時出力する音声データファイルの拡張子
  final String audioExtension;
  // 録音の間隔（秒）
  final int recordIntervalSeconds;
  // 録音デバイス（相手からの音声）
  final InputDevice? inputDevice;
  // 録音デバイス（自分の声=マイクの音声）
  final InputDevice? ownOutDevice;
  // サマリーのプロンプト
  final String summaryPrompt;
  // アプリ名
  final String appName;
  // アプリバージョン
  final String appVersion;
  // テーマモード
  final ThemeMode themeMode;

  static const String defaultSummaryPrompt = '次の文章は複数人の会話を文字起こしして時系列に繋げて作成した文章です。このテキストに含まれる主要な情報を要約してください:';

  String createSoundFilePath({required String alias}) {
    final dateFormat = DateFormat('yyyyMMddHHmmss');
    final fileName = '${alias}_${dateFormat.format(DateTime.now())}.$audioExtension';
    return path.join(cacheDirPath, fileName);
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  AppSetting copyWith({
    String? apiKey,
    String? cacheDirPath,
    String? audioExtension,
    int? recordIntervalSeconds,
    InputDevice? inputDevice,
    InputDevice? ownOutDevice,
    String? summaryPrompt,
    String? appName,
    String? appVersion,
    ThemeMode? themeMode,
  }) {
    return AppSetting(
      apiKey: apiKey ?? this.apiKey,
      cacheDirPath: cacheDirPath ?? this.cacheDirPath,
      audioExtension: audioExtension ?? this.audioExtension,
      recordIntervalSeconds: recordIntervalSeconds ?? this.recordIntervalSeconds,
      inputDevice: inputDevice ?? this.inputDevice,
      ownOutDevice: ownOutDevice ?? this.ownOutDevice,
      summaryPrompt: summaryPrompt ?? this.summaryPrompt,
      appName: appName ?? this.appName,
      appVersion: appVersion ?? this.appVersion,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

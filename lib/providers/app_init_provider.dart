import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record_to_talk/models/app_setting.dart';
import 'package:record_to_talk/repository/app_setting_repository.dart';

///
/// ここでアプリに必要な初期処理を行う
///
final appInitFutureProvider = FutureProvider((ref) async {
  final second = await ref.read(appSettingsRepositoryProvider).getRecordIntervalSeconds();
  final summaryPrompt = await ref.read(appSettingsRepositoryProvider).getSummaryPrompt();
  final cacheDir = await getApplicationCacheDirectory();
  final packageInfo = await PackageInfo.fromPlatform();
  final isDarkMode = await ref.read(appSettingsRepositoryProvider).isDarkMode();

  await ref.read(appSettingProvider.notifier).refresh(
        cacheDirPath: cacheDir.path,
        recordIntervalSecond: second,
        summaryPrompt: summaryPrompt,
        appName: packageInfo.appName,
        appVersion: packageInfo.version,
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      );
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record_to_talk/repository/local/shared_prefs.dart';

final appSettingsRepositoryProvider = Provider((ref) => _AppSettingRepository(ref));

class _AppSettingRepository {
  _AppSettingRepository(this._ref);

  final Ref _ref;

  Future<int?> getRecordIntervalSeconds() async {
    return await _ref.read(sharedPrefsProvider).getRecordIntervalSeconds();
  }

  Future<void> saveRecordIntervalSeconds(int value) async {
    await _ref.read(sharedPrefsProvider).saveRecordIntervalSeconds(value);
  }

  Future<bool> isDarkMode() async {
    return await _ref.read(sharedPrefsProvider).isDarkMode();
  }

  Future<void> changeThemeMode(bool isDarkMode) async {
    await _ref.read(sharedPrefsProvider).saveDarkMode(isDarkMode);
  }

  Future<String?> getSummaryPrompt() async {
    return await _ref.read(sharedPrefsProvider).getSummaryPrompt();
  }

  Future<void> saveSummaryPrompt(String value) async {
    await _ref.read(sharedPrefsProvider).setSummaryPrompt(value);
  }
}

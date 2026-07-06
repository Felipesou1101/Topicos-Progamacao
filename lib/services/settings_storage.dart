import '../models/app_settings.dart';

abstract class SettingsStorage {
  Future<AppSettings> loadSettings();

  Future<void> saveSettings(AppSettings settings);
}

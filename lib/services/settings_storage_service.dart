import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';
import 'settings_storage.dart';

class SettingsStorageService implements SettingsStorage {
  static const String _settingsKey = 'app_settings';

  @override
  Future<AppSettings> loadSettings() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_settingsKey);

    if (raw == null || raw.isEmpty) {
      return const AppSettings();
    }

    return AppSettings.fromMap(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_settingsKey, jsonEncode(settings.toMap()));
  }
}

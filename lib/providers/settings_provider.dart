import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../services/settings_storage.dart';
import '../services/settings_storage_service.dart';
import '../utils/app_colors.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider({SettingsStorage? storage}) : _storage = storage ?? SettingsStorageService();

  final SettingsStorage _storage;

  AppSettings _settings = const AppSettings();
  bool _isLoading = false;

  AppSettings get settings => _settings;

  bool get isLoading => _isLoading;

  AppTheme get activeTheme {
    final themeId = _settings.themeId;
    if (themeId == 'custom') {
      final pColor = _settings.customPrimaryColor ?? 0xFF00E676;
      final sColor = _settings.customSecondaryColor ?? 0xFF00D4FF;
      final bColor = _settings.customBackgroundColor ?? 0xFF0B1020;
      final cColor = _settings.customCardColor ?? 0xFF151B2D;

      final primaryColor = Color(pColor);
      final secondaryColor = Color(sColor);
      final bgColor = Color(bColor);
      final cardColor = Color(cColor);

      // Derive soft/light variations for background and card
      final hslBg = HSLColor.fromColor(bgColor);
      final hslCard = HSLColor.fromColor(cardColor);

      final backgroundSoft = hslBg.withLightness((hslBg.lightness + 0.05).clamp(0.0, 1.0)).toColor();
      final cardLight = hslCard.withLightness((hslCard.lightness + 0.05).clamp(0.0, 1.0)).toColor();

      return AppTheme(
        id: 'custom',
        name: 'Personalizado',
        background: bgColor,
        backgroundSoft: backgroundSoft,
        card: cardColor,
        cardLight: cardLight,
        green: primaryColor,
        cyan: secondaryColor,
        purple: const Color(0xFF8A5CFF),
        yellow: const Color(0xFFFFC857),
        red: const Color(0xFFFF5C7A),
        muted: const Color(0xFFAAB2C8),
        textPrimary: const Color(0xFFFFFFFF),
        border: primaryColor.withValues(alpha: 0.15),
      );
    }

    return AppColors.themes.firstWhere(
      (theme) => theme.id == themeId,
      orElse: () => AppColors.ninjaDark,
    );
  }

  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();

    _settings = await _storage.loadSettings();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> completeOnboarding({
    required String userName,
    required double? monthlyBudget,
  }) async {
    _settings = _settings.copyWith(
      onboardingCompleted: true,
      userName: userName.trim(),
      monthlyBudget: monthlyBudget,
      clearMonthlyBudget: monthlyBudget == null,
    );
    await _storage.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> updateSettings({
    required String userName,
    required double? monthlyBudget,
  }) async {
    _settings = _settings.copyWith(
      userName: userName.trim(),
      monthlyBudget: monthlyBudget,
      clearMonthlyBudget: monthlyBudget == null,
    );
    await _storage.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> updateTheme(
    String themeId, {
    int? primary,
    int? secondary,
    int? background,
    int? card,
  }) async {
    _settings = _settings.copyWith(
      themeId: themeId,
      customPrimaryColor: primary,
      customSecondaryColor: secondary,
      customBackgroundColor: background,
      customCardColor: card,
    );
    await _storage.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> resetOnboarding() async {
    _settings = const AppSettings();
    await _storage.saveSettings(_settings);
    notifyListeners();
  }
}

import 'package:assinaturas_ninja/models/app_settings.dart';
import 'package:assinaturas_ninja/providers/settings_provider.dart';
import 'package:assinaturas_ninja/services/settings_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeSettingsStorage implements SettingsStorage {
  FakeSettingsStorage([AppSettings? initial]) : stored = initial ?? const AppSettings();

  AppSettings stored;

  @override
  Future<AppSettings> loadSettings() async => stored;

  @override
  Future<void> saveSettings(AppSettings settings) async {
    stored = settings;
  }
}

void main() {
  test('loads default settings with onboarding pending', () async {
    final provider = SettingsProvider(storage: FakeSettingsStorage());

    await provider.loadSettings();

    expect(provider.settings.onboardingCompleted, isFalse);
    expect(provider.settings.userName, isEmpty);
    expect(provider.settings.monthlyBudget, isNull);
  });

  test('saves onboarding settings', () async {
    final storage = FakeSettingsStorage();
    final provider = SettingsProvider(storage: storage);

    await provider.completeOnboarding(userName: 'Dede', monthlyBudget: 180);

    expect(provider.settings.onboardingCompleted, isTrue);
    expect(provider.settings.userName, 'Dede');
    expect(provider.settings.monthlyBudget, 180);
    expect(storage.stored.onboardingCompleted, isTrue);
  });

  test('clears onboarding when reset is requested', () async {
    final provider = SettingsProvider(
      storage: FakeSettingsStorage(
        const AppSettings(onboardingCompleted: true, userName: 'Dede', monthlyBudget: 180),
      ),
    );

    await provider.loadSettings();
    await provider.resetOnboarding();

    expect(provider.settings.onboardingCompleted, isFalse);
    expect(provider.settings.userName, isEmpty);
    expect(provider.settings.monthlyBudget, isNull);
  });
}

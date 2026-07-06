import 'package:assinaturas_ninja/models/app_settings.dart';
import 'package:assinaturas_ninja/models/subscription.dart';
import 'package:assinaturas_ninja/providers/settings_provider.dart';
import 'package:assinaturas_ninja/providers/subscription_provider.dart';
import 'package:assinaturas_ninja/screens/onboarding_screen.dart';
import 'package:assinaturas_ninja/services/settings_storage.dart';
import 'package:assinaturas_ninja/services/subscription_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class TestSettingsStorage implements SettingsStorage {
  AppSettings settings = const AppSettings();

  @override
  Future<AppSettings> loadSettings() async => settings;

  @override
  Future<void> saveSettings(AppSettings settings) async {
    this.settings = settings;
  }
}

class TestSubscriptionStorage implements SubscriptionStorage {
  @override
  Future<bool> hasStoredSubscriptions() async => false;

  @override
  Future<List<Subscription>> loadSubscriptions() async => [];

  @override
  Future<void> saveSubscriptions(List<Subscription> subscriptions) async {}
}

void main() {
  testWidgets('onboarding offers clean start and optional demonstration data', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SettingsProvider(storage: TestSettingsStorage())),
          ChangeNotifierProvider(
            create: (_) => SubscriptionProvider(storage: TestSubscriptionStorage()),
          ),
        ],
        child: const MaterialApp(home: OnboardingScreen()),
      ),
    );

    expect(find.text('Organize suas assinaturas sem surpresa.'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -480));
    await tester.pump();
    expect(find.text('Começar vazio'), findsOneWidget);
    expect(find.text('Explorar com exemplos'), findsOneWidget);
  });

  testWidgets('clean start completes onboarding without inserting subscriptions', (tester) async {
    final settingsStorage = TestSettingsStorage();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SettingsProvider(storage: settingsStorage)),
          ChangeNotifierProvider(
            create: (_) => SubscriptionProvider(storage: TestSubscriptionStorage()),
          ),
        ],
        child: const MaterialApp(home: OnboardingScreen()),
      ),
    );

    await tester.drag(find.byType(ListView), const Offset(0, -480));
    await tester.pump();
    await tester.tap(find.text('Começar vazio'));
    await tester.pumpAndSettle();

    expect(settingsStorage.settings.onboardingCompleted, isTrue);
    expect(find.text('Nenhuma assinatura cadastrada ainda.'), findsOneWidget);
  });
}

import 'package:assinaturas_ninja/models/app_settings.dart';
import 'package:assinaturas_ninja/models/subscription.dart';
import 'package:assinaturas_ninja/providers/settings_provider.dart';
import 'package:assinaturas_ninja/services/settings_storage.dart';
import 'package:assinaturas_ninja/widgets/empty_state.dart';
import 'package:assinaturas_ninja/widgets/status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class FakeSettingsStorage implements SettingsStorage {
  @override
  Future<AppSettings> loadSettings() async => const AppSettings();

  @override
  Future<void> saveSettings(AppSettings settings) async {}
}

void main() {
  testWidgets('EmptyState shows the required empty list copy', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<SettingsProvider>(
        create: (_) => SettingsProvider(storage: FakeSettingsStorage()),
        child: MaterialApp(
          home: Scaffold(
            body: EmptyState(onAdd: () {}),
          ),
        ),
      ),
    );

    expect(find.text('Nenhuma assinatura cadastrada ainda.'), findsOneWidget);
    expect(
      find.text('Adicione seus serviços recorrentes e descubra quanto eles pesam no mês.'),
      findsOneWidget,
    );
    expect(find.text('Adicionar assinatura'), findsOneWidget);
  });

  testWidgets('StatusChip renders active status label', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<SettingsProvider>(
        create: (_) => SettingsProvider(storage: FakeSettingsStorage()),
        child: const MaterialApp(
          home: Scaffold(
            body: StatusChip(status: SubscriptionStatus.active),
          ),
        ),
      ),
    );

    expect(find.text('Ativa'), findsOneWidget);
  });
}

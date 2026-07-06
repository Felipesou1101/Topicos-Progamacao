import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../providers/subscription_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/brand_mark.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _nameController = TextEditingController();
  final _budgetController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 34, 24, 26),
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: BrandMark(size: 72),
            ),
            const SizedBox(height: 28),
            const Text(
              'Organize suas assinaturas sem surpresa.',
              style: TextStyle(fontSize: 31, height: 1.1, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            Text(
              'Acompanhe cobranças recorrentes, entenda seus gastos e decida o que vale manter.',
              style: TextStyle(color: theme.muted, fontSize: 16, height: 1.45),
            ),
            const SizedBox(height: 30),
            const _FeatureRow(
              icon: Icons.lock_outline_rounded,
              title: 'Tudo no seu aparelho',
              subtitle: 'Seus dados ficam armazenados localmente.',
            ),
            const _FeatureRow(
              icon: Icons.bar_chart_rounded,
              title: 'Gastos claros',
              subtitle: 'Totais mensais, anuais e por categoria.',
            ),
            const _FeatureRow(
              icon: Icons.event_available_rounded,
              title: 'Vencimentos à vista',
              subtitle: 'Destaques para cobranças próximas.',
            ),
            const SizedBox(height: 22),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Como podemos chamar você? (opcional)',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _budgetController,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]'))],
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Limite mensal desejado (opcional)',
                prefixIcon: Icon(Icons.savings_outlined),
                prefixText: 'R\$ ',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saving ? null : () => _finish(loadExamples: false),
              child: const Text('Começar vazio'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _saving ? null : () => _finish(loadExamples: true),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.cyan,
                side: BorderSide(color: theme.cyan),
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: const Text('Explorar com exemplos'),
            ),
            const SizedBox(height: 12),
            Text(
              'Os exemplos são apenas demonstração e podem ser apagados nos ajustes.',
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.muted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  double? _parseBudget() {
    final text = _budgetController.text.trim();
    if (text.isEmpty) {
      return null;
    }
    return double.tryParse(text.replaceAll('.', '').replaceAll(',', '.'));
  }

  Future<void> _finish({required bool loadExamples}) async {
    setState(() => _saving = true);
    final subscriptions = context.read<SubscriptionProvider>();
    final settings = context.read<SettingsProvider>();

    if (loadExamples) {
      await subscriptions.replaceWithSampleData();
    } else {
      await subscriptions.initializeEmpty();
    }
    await settings.completeOnboarding(
      userName: _nameController.text,
      monthlyBudget: _parseBudget(),
    );

    if (!mounted) {
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: theme.card,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: theme.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                Text(subtitle, style: TextStyle(color: theme.muted, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

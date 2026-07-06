import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../providers/subscription_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/brand_mark.dart';
import 'onboarding_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _budgetController;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>().settings;
    _nameController = TextEditingController(text: settings.userName);
    _budgetController = TextEditingController(
      text: settings.monthlyBudget?.toStringAsFixed(2).replaceAll('.', ',') ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final activeThemeId = settingsProvider.settings.themeId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 26),
          children: [
            Row(
              children: [
                const BrandMark(size: 54),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Assinaturas Ninja', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    Text('Dados locais e privados', style: TextStyle(color: theme.muted)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 26),
            const _SettingsLabel('Perfil financeiro'),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Seu nome',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _budgetController,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]'))],
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Meta máxima por mês',
                prefixIcon: Icon(Icons.track_changes_rounded),
                prefixText: 'R\$ ',
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: _saveProfile,
              icon: const Icon(Icons.save_rounded),
              label: const Text('Salvar preferências'),
            ),
            const SizedBox(height: 28),
            const _SettingsLabel('Aparência e Tema'),
            SizedBox(
              height: 76,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...AppColors.themes.map((t) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: _ThemePreviewCard(
                          theme: t,
                          selected: activeThemeId == t.id,
                          onTap: () {
                            settingsProvider.updateTheme(t.id);
                          },
                        ),
                      )),
                  _ThemePreviewCard(
                    theme: settingsProvider.activeTheme,
                    selected: activeThemeId == 'custom',
                    onTap: () {
                      settingsProvider.updateTheme('custom');
                    },
                    isCustom: true,
                  ),
                ],
              ),
            ),
            if (activeThemeId == 'custom') ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: theme.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personalizar Cores',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: theme.green),
                    ),
                    const SizedBox(height: 14),
                    _CustomColorPickerRow(
                      label: 'Cor de Fundo',
                      selectedColor: Color(settingsProvider.settings.customBackgroundColor ?? 0xFF0B1020),
                      options: const [
                        Color(0xFF0B1020),
                        Color(0xFF080C14),
                        Color(0xFF12072B),
                        Color(0xFF0A1410),
                        Color(0xFF1A1010),
                        Color(0xFF121212),
                      ],
                      onColorSelected: (color) {
                        settingsProvider.updateTheme(
                          'custom',
                          primary: settingsProvider.settings.customPrimaryColor,
                          secondary: settingsProvider.settings.customSecondaryColor,
                          background: color.toARGB32(),
                          card: settingsProvider.settings.customCardColor,
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    _CustomColorPickerRow(
                      label: 'Cor dos Cards',
                      selectedColor: Color(settingsProvider.settings.customCardColor ?? 0xFF151B2D),
                      options: const [
                        Color(0xFF151B2D),
                        Color(0xFF111C34),
                        Color(0xFF1E0E38),
                        Color(0xFF142921),
                        Color(0xFF332020),
                        Color(0xFF1E1E1E),
                      ],
                      onColorSelected: (color) {
                        settingsProvider.updateTheme(
                          'custom',
                          primary: settingsProvider.settings.customPrimaryColor,
                          secondary: settingsProvider.settings.customSecondaryColor,
                          background: settingsProvider.settings.customBackgroundColor,
                          card: color.toARGB32(),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    _CustomColorPickerRow(
                      label: 'Cor Principal (Principal)',
                      selectedColor: Color(settingsProvider.settings.customPrimaryColor ?? 0xFF00E676),
                      options: const [
                        Color(0xFF00E676),
                        Color(0xFF00D4FF),
                        Color(0xFF2979FF),
                        Color(0xFFFF0055),
                        Color(0xFF8A5CFF),
                        Color(0xFFFFC857),
                        Color(0xFFFFA726),
                      ],
                      onColorSelected: (color) {
                        settingsProvider.updateTheme(
                          'custom',
                          primary: color.toARGB32(),
                          secondary: settingsProvider.settings.customSecondaryColor,
                          background: settingsProvider.settings.customBackgroundColor,
                          card: settingsProvider.settings.customCardColor,
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    _CustomColorPickerRow(
                      label: 'Cor Secundária (Acento)',
                      selectedColor: Color(settingsProvider.settings.customSecondaryColor ?? 0xFF00D4FF),
                      options: const [
                        Color(0xFF00D4FF),
                        Color(0xFF00E676),
                        Color(0xFF00B0FF),
                        Color(0xFFFF00FF),
                        Color(0xFFFF7043),
                        Color(0xFFFFD54F),
                      ],
                      onColorSelected: (color) {
                        settingsProvider.updateTheme(
                          'custom',
                          primary: settingsProvider.settings.customPrimaryColor,
                          secondary: color.toARGB32(),
                          background: settingsProvider.settings.customBackgroundColor,
                          card: settingsProvider.settings.customCardColor,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 28),
            const _SettingsLabel('Dados'),
            _ActionTile(
              icon: Icons.auto_awesome_rounded,
              color: theme.cyan,
              title: 'Carregar dados de demonstração',
              subtitle: 'Substitui a lista atual pelos exemplos do protótipo.',
              onTap: () => _replaceWithSamples(context),
            ),
            _ActionTile(
              icon: Icons.delete_sweep_outlined,
              color: theme.red,
              title: 'Apagar todas as assinaturas',
              subtitle: 'Mantém suas configurações e zera os registros.',
              onTap: () => _clearSubscriptions(context),
            ),
            _ActionTile(
              icon: Icons.restart_alt_rounded,
              color: theme.yellow,
              title: 'Refazer configuração inicial',
              subtitle: 'Volta para a tela de boas-vindas.',
              onTap: () => _restartOnboarding(context),
            ),
          ],
        ),
      ),
    );
  }

  double? _budgetValue() {
    final raw = _budgetController.text.trim();
    if (raw.isEmpty) {
      return null;
    }
    return double.tryParse(raw.replaceAll('.', '').replaceAll(',', '.'));
  }

  Future<void> _saveProfile() async {
    await context.read<SettingsProvider>().updateSettings(
      userName: _nameController.text,
      monthlyBudget: _budgetValue(),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preferências salvas.')),
      );
    }
  }

  Future<void> _replaceWithSamples(BuildContext context) async {
    final subscriptions = context.read<SubscriptionProvider>();
    if (!await _confirm(
      context,
      title: 'Carregar demonstração?',
      message: 'As assinaturas atuais serão substituídas pelos dados de exemplo.',
    )) {
      return;
    }
    await subscriptions.replaceWithSampleData();
  }

  Future<void> _clearSubscriptions(BuildContext context) async {
    final subscriptions = context.read<SubscriptionProvider>();
    if (!await _confirm(
      context,
      title: 'Apagar assinaturas?',
      message: 'Todos os registros serão excluídos. Esta ação não pode ser desfeita.',
    )) {
      return;
    }
    await subscriptions.clearAll();
  }

  Future<void> _restartOnboarding(BuildContext context) async {
    final settings = context.read<SettingsProvider>();
    if (!await _confirm(
      context,
      title: 'Refazer configuração?',
      message: 'Você voltará à introdução. Suas assinaturas permanecem até escolher começar vazio.',
    )) {
      return;
    }
    await settings.resetOnboarding();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const OnboardingScreen()),
        (_) => false,
      );
    }
  }

  Future<bool> _confirm(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Confirmar'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class _SettingsLabel extends StatelessWidget {
  const _SettingsLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: TextStyle(color: theme.muted, fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: theme.muted),
          ],
        ),
      ),
    );
  }
}

class _ThemePreviewCard extends StatelessWidget {
  final AppTheme theme;
  final bool selected;
  final VoidCallback onTap;
  final bool isCustom;

  const _ThemePreviewCard({
    required this.theme,
    required this.selected,
    required this.onTap,
    this.isCustom = false,
  });

  @override
  Widget build(BuildContext context) {
    final activeTheme = AppColors.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 105,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? theme.background : activeTheme.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? theme.green : activeTheme.border,
            width: selected ? 2.5 : 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ColorCircle(color: theme.background, size: 14, border: theme.border),
                const SizedBox(width: 4),
                _ColorCircle(color: theme.green, size: 14),
                const SizedBox(width: 4),
                _ColorCircle(color: theme.cyan, size: 14),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              isCustom ? 'Personalizado' : theme.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: selected ? theme.green : activeTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorCircle extends StatelessWidget {
  final Color color;
  final double size;
  final Color? border;

  const _ColorCircle({required this.color, required this.size, this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: border != null ? Border.all(color: border!, width: 0.5) : null,
      ),
    );
  }
}

class _CustomColorPickerRow extends StatelessWidget {
  final String label;
  final Color selectedColor;
  final List<Color> options;
  final ValueChanged<Color> onColorSelected;

  const _CustomColorPickerRow({
    required this.label,
    required this.selectedColor,
    required this.options,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: theme.muted, fontSize: 12)),
        const SizedBox(height: 8),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: options.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final color = options[index];
              final isSelected = selectedColor.toARGB32() == color.toARGB32();
              return InkWell(
                onTap: () => onColorSelected(color),
                customBorder: const CircleBorder(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? theme.green : Colors.transparent,
                      width: isSelected ? 3.0 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: theme.green.withValues(alpha: 0.3),
                              blurRadius: 6,
                              spreadRadius: 1,
                            )
                          ]
                        : null,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check_rounded,
                          color: ThemeData.estimateBrightnessForColor(color) == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          size: 18,
                        )
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

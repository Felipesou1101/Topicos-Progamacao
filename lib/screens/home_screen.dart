import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/subscription.dart';
import '../providers/settings_provider.dart';
import '../providers/subscription_provider.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';
import '../widgets/category_icon.dart';
import '../widgets/brand_mark.dart';
import '../widgets/empty_state.dart';
import '../widgets/summary_card.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import 'subscription_detail_screen.dart';
import 'subscription_form_screen.dart';
import 'subscriptions_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    final pages = [
      const _DashboardPage(),
      const SubscriptionsScreen(),
      const ReportsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        backgroundColor: theme.backgroundSoft,
        indicatorColor: theme.green.withValues(alpha: 0.18),
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt_rounded),
            label: 'Assinaturas',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Relatórios',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune_rounded),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}

class _DashboardPage extends StatelessWidget {
  const _DashboardPage();

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Consumer<SubscriptionProvider>(
      builder: (context, provider, _) {
        if (provider.subscriptions.isEmpty) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 18, 20, 0),
                    child: _Header(),
                  ),
                  Expanded(child: EmptyState(onAdd: () => _openForm(context))),
                ],
              ),
            ),
          );
        }

        final mostExpensive = provider.mostExpensive;
        final nextCharge = provider.upcomingCharges.isNotEmpty ? provider.upcomingCharges.first : null;
        final nextChargeDays = nextCharge == null ? null : provider.daysUntilDue(nextCharge);

        final dueThisWeek = provider.dueThisWeek;
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              children: [
                const _Header(),
                const SizedBox(height: 24),
                _TotalCard(total: provider.totalMonthly),
                const SizedBox(height: 16),
                SizedBox(
                  height: 174,
                  child: Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          icon: Icons.groups_rounded,
                          title: 'Ativas',
                          value: provider.activeCount.toString(),
                          accent: theme.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SummaryCard(
                          icon: Icons.star_rounded,
                          title: 'Mais cara',
                          value: mostExpensive?.name ?? '-',
                          subtitle: mostExpensive == null ? null : formatMoney(mostExpensive.price),
                          accent: theme.purple,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SummaryCard(
                          icon: Icons.calendar_month_rounded,
                          title: 'Próxima',
                          value: nextCharge?.name ?? '-',
                          subtitle: nextChargeDays == null ? null : dueLabel(nextChargeDays),
                          accent: theme.cyan,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                if (dueThisWeek.isNotEmpty) ...[
                  _DueAlert(count: dueThisWeek.length),
                  const SizedBox(height: 22),
                ],
                const Text(
                  'Próximas cobranças',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 14),
                _UpcomingChargesList(items: provider.upcomingCharges.take(4).toList()),
                const SizedBox(height: 22),
                ElevatedButton.icon(
                  onPressed: () => _openForm(context),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Adicionar assinatura'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openForm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const SubscriptionFormScreen()),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    final userName = context.watch<SettingsProvider>().settings.userName;
    return Row(
      children: [
        const BrandMark(size: 54),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Assinaturas Ninja',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 2),
              Text(
                userName.isEmpty ? 'Controle seus gastos recorrentes' : 'Olá, $userName',
                style: TextStyle(color: theme.muted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [theme.green, theme.cyan],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.green.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gasto mensal',
                  style: TextStyle(color: Color(0xDDFFFFFF), fontSize: 16),
                ),
                const SizedBox(height: 10),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    formatMoney(total),
                    style: const TextStyle(
                      color: Color(0xEFFFFFFF),
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Total das assinaturas ativas',
                  style: TextStyle(color: Color(0xCCFFFFFF)),
                ),
              ],
            ),
          ),
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.16),
            ),
            child: const Icon(Icons.trending_up_rounded, color: Colors.white70, size: 38),
          ),
        ],
      ),
    );
  }
}

class _UpcomingChargesList extends StatelessWidget {
  const _UpcomingChargesList({required this.items});

  final List<Subscription> items;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    if (items.isEmpty) {
      return Text(
        'Nenhuma cobrança ativa no momento.',
        style: TextStyle(color: theme.muted),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: theme.border),
      ),
      child: Column(
        children: [
          for (final item in items) _UpcomingChargeTile(subscription: item),
        ],
      ),
    );
  }
}

class _DueAlert extends StatelessWidget {
  const _DueAlert({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: theme.yellow.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.yellow.withValues(alpha: 0.36)),
      ),
      child: Row(
        children: [
          Icon(Icons.notifications_active_outlined, color: theme.yellow),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$count cobrança(s) vencem nos próximos 5 dias.',
              style: TextStyle(color: theme.yellow, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingChargeTile extends StatelessWidget {
  const _UpcomingChargeTile({required this.subscription});

  final Subscription subscription;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Consumer<SubscriptionProvider>(
      builder: (context, provider, _) {
        final dueSoon = provider.isDueSoon(subscription);
        final dueToday = provider.isDueToday(subscription);
        final color = dueToday
            ? theme.red
            : dueSoon
            ? theme.yellow
            : theme.cyan;

        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => SubscriptionDetailScreen(subscriptionId: subscription.id),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CategoryIcon(category: subscription.category),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subscription.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatMoney(subscription.price),
                        style: TextStyle(color: theme.muted),
                      ),
                    ],
                  ),
                ),
                Text(
                  'dia ${subscription.dueDay}',
                  style: TextStyle(color: color, fontWeight: FontWeight.w900),
                ),
                Icon(Icons.chevron_right_rounded, color: theme.muted),
              ],
            ),
          ),
        );
      },
    );
  }
}

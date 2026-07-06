import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/subscription.dart';
import '../providers/subscription_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/empty_state.dart';
import '../widgets/subscription_card.dart';
import 'subscription_detail_screen.dart';
import 'subscription_form_screen.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Consumer<SubscriptionProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Assinaturas',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            actions: [
              IconButton(
                tooltip: 'Adicionar assinatura',
                onPressed: () => _openForm(context),
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
          body: SafeArea(
            child: provider.subscriptions.isEmpty
                ? EmptyState(onAdd: () => _openForm(context))
                : Column(
                    children: [
                       _SearchAndSort(provider: provider),
                      const SizedBox(height: 10),
                      _FilterBar(provider: provider),
                      Expanded(
                        child: provider.filteredSubscriptions.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Text(
                                    'Nenhuma assinatura encontrada para este filtro.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: theme.muted),
                                  ),
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                                itemBuilder: (context, index) {
                                  final subscription = provider.filteredSubscriptions[index];
                                  return SubscriptionCard(
                                    subscription: subscription,
                                    daysUntilDue: provider.daysUntilDue(subscription),
                                    isDueToday: provider.isDueToday(subscription),
                                    isDueSoon: provider.isDueSoon(subscription),
                                    onMenuSelected: (action) =>
                                        _handleAction(context, provider, subscription, action),
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) => SubscriptionDetailScreen(
                                          subscriptionId: subscription.id,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (_, _) => const SizedBox(height: 12),
                                itemCount: provider.filteredSubscriptions.length,
                              ),
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

  Future<void> _handleAction(
    BuildContext context,
    SubscriptionProvider provider,
    Subscription subscription,
    String action,
  ) async {
    switch (action) {
      case 'toggle':
        final nextStatus = subscription.status == SubscriptionStatus.active
            ? SubscriptionStatus.paused
            : SubscriptionStatus.active;
        await provider.changeStatus(subscription.id, nextStatus);
        return;
      case 'edit':
        if (context.mounted) {
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => SubscriptionFormScreen(subscription: subscription),
            ),
          );
        }
        return;
      case 'delete':
        final theme = AppColors.of(context, listen: false);
        final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Excluir assinatura?'),
            content: Text('Deseja remover ${subscription.name}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Excluir', style: TextStyle(color: theme.red)),
              ),
            ],
          ),
        );
        if (shouldDelete == true) {
          await provider.deleteSubscription(subscription.id);
        }
        return;
    }
  }
}

class _SearchAndSort extends StatelessWidget {
  const _SearchAndSort({required this.provider});

  final SubscriptionProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: provider.setSearchQuery,
              decoration: const InputDecoration(
                hintText: 'Buscar assinatura',
                prefixIcon: Icon(Icons.search_rounded),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 10),
          PopupMenuButton<SubscriptionSort>(
            tooltip: 'Ordenar',
            initialValue: provider.sortOrder,
            onSelected: provider.setSortOrder,
            itemBuilder: (_) => SubscriptionSort.values
                .map((order) => PopupMenuItem(value: order, child: Text(order.label)))
                .toList(),
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: theme.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.border),
              ),
              child: Icon(Icons.sort_rounded, color: theme.cyan),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.provider});

  final SubscriptionProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: SubscriptionFilter.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = SubscriptionFilter.values[index];
          final selected = provider.filter == filter;
          return ChoiceChip(
            selected: selected,
            label: Text(filter.label),
            onSelected: (_) => provider.setFilter(filter),
            selectedColor: theme.green.withValues(alpha: 0.2),
            backgroundColor: theme.card,
            side: BorderSide(color: selected ? theme.green : theme.border),
            labelStyle: TextStyle(
              color: selected ? theme.green : theme.muted,
              fontWeight: FontWeight.w800,
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: theme.cyan.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add_card_rounded, color: theme.cyan, size: 36),
            ),
            const SizedBox(height: 22),
            const Text(
              'Nenhuma assinatura cadastrada ainda.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            Text(
              'Adicione seus serviços recorrentes e descubra quanto eles pesam no mês.',
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.muted, height: 1.4),
            ),
            const SizedBox(height: 22),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Adicionar assinatura'),
            ),
          ],
        ),
      ),
    );
  }
}

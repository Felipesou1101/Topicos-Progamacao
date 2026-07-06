import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class CategoryIcon extends StatelessWidget {
  const CategoryIcon({super.key, required this.category, this.size = 44});

  final String category;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    final normalizedCategory = category
        .toLowerCase()
        .replaceAll('ú', 'u')
        .replaceAll('í', 'i')
        .replaceAll('ç', 'c')
        .replaceAll('ã', 'a')
        .replaceAll('é', 'e')
        .replaceAll('á', 'a');
    final icon = switch (normalizedCategory) {
      'streaming' => Icons.play_arrow_rounded,
      'musica' => Icons.music_note_rounded,
      'jogos' => Icons.sports_esports_rounded,
      'nuvem' => Icons.cloud_rounded,
      'saude' => Icons.favorite_rounded,
      'educacao' => Icons.school_rounded,
      _ => Icons.auto_awesome_rounded,
    };
    final color = switch (normalizedCategory) {
      'streaming' => theme.purple,
      'musica' => theme.green,
      'jogos' => theme.cyan,
      'nuvem' => const Color(0xFF3A7BFF),
      'saude' => theme.red,
      'educacao' => theme.yellow,
      _ => theme.cyan,
    };

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.8), width: 1.5),
      ),
      child: Icon(icon, color: color, size: size * 0.52),
    );
  }
}

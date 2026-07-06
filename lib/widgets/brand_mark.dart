import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 54});

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.25),
        gradient: LinearGradient(
          colors: [theme.green, theme.cyan],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.cyan.withValues(alpha: 0.20),
            blurRadius: size * 0.36,
            offset: Offset(0, size * 0.14),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _NinjaMarkPainter(
          backgroundColor: theme.background,
          primaryColor: theme.green,
        ),
      ),
    );
  }
}

class _NinjaMarkPainter extends CustomPainter {
  final Color backgroundColor;
  final Color primaryColor;

  _NinjaMarkPainter({
    required this.backgroundColor,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maskPaint = Paint()..color = backgroundColor;
    final eyePaint = Paint()..color = primaryColor;
    final strokePaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = size.width * 0.06
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final mask = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: size.width * 0.58, height: size.height * 0.46),
      Radius.circular(size.width * 0.12),
    );
    canvas.drawRRect(mask, maskPaint);
    canvas.drawLine(
      Offset(size.width * 0.19, size.height * 0.38),
      Offset(size.width * 0.08, size.height * 0.27),
      strokePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.81, size.height * 0.38),
      Offset(size.width * 0.92, size.height * 0.27),
      strokePaint,
    );
    canvas.drawCircle(Offset(size.width * 0.41, size.height * 0.51), size.width * 0.045, eyePaint);
    canvas.drawCircle(Offset(size.width * 0.59, size.height * 0.51), size.width * 0.045, eyePaint);
  }

  @override
  bool shouldRepaint(covariant _NinjaMarkPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor || oldDelegate.primaryColor != primaryColor;
  }
}

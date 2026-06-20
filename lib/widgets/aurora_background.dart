import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

/// Soft aurora blobs + light vector accents (matches auth screens).
class AuroraBackground extends StatelessWidget {
  const AuroraBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(color: AppColors.canvas),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -90,
              right: -70,
              child: _GradientBlob(
                size: 260,
                colors: [
                  AppColors.orange.withValues(alpha: 0.55),
                  AppColors.orange.withValues(alpha: 0.0),
                ],
              ),
            ),
            Positioned(
              top: 120,
              left: -90,
              child: _GradientBlob(
                size: 240,
                colors: [
                  AppColors.indigo.withValues(alpha: 0.45),
                  AppColors.indigo.withValues(alpha: 0.0),
                ],
              ),
            ),
            Positioned(
              bottom: -110,
              right: -60,
              child: _GradientBlob(
                size: 300,
                colors: [
                  AppColors.violet.withValues(alpha: 0.40),
                  AppColors.violet.withValues(alpha: 0.0),
                ],
              ),
            ),
            const Positioned.fill(child: _VectorAccents()),
          ],
        ),
      ),
    );
  }
}

class _GradientBlob extends StatelessWidget {
  const _GradientBlob({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors),
      ),
    );
  }
}

class _VectorAccents extends StatelessWidget {
  const _VectorAccents();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _VectorAccentsPainter(),
        size: Size.infinite,
      ),
    );
  }
}

class _VectorAccentsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _drawRing(
      canvas,
      center: Offset(size.width * 0.12, size.height * 0.22),
      radius: 54,
      color: AppColors.indigo.withValues(alpha: 0.18),
      strokeWidth: 1.6,
      startAngle: 0.4,
      sweepAngle: math.pi * 1.35,
    );
    _drawRing(
      canvas,
      center: Offset(size.width * 0.88, size.height * 0.18),
      radius: 42,
      color: AppColors.orange.withValues(alpha: 0.22),
      strokeWidth: 1.4,
      startAngle: math.pi * 0.85,
      sweepAngle: math.pi * 1.1,
    );
    _drawRing(
      canvas,
      center: Offset(size.width * 0.78, size.height * 0.72),
      radius: 68,
      color: AppColors.violet.withValues(alpha: 0.16),
      strokeWidth: 1.2,
      startAngle: math.pi * 1.2,
      sweepAngle: math.pi * 0.95,
    );

    _drawDots(canvas, size);
    _drawWave(canvas, size);
  }

  void _drawRing(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required Color color,
    required double strokeWidth,
    required double startAngle,
    required double sweepAngle,
  }) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  void _drawDots(Canvas canvas, Size size) {
    final dots = <(Offset, Color, double)>[
      (Offset(size.width * 0.22, size.height * 0.14), AppColors.orange, 4),
      (Offset(size.width * 0.68, size.height * 0.10), AppColors.indigo, 3),
      (Offset(size.width * 0.92, size.height * 0.42), AppColors.violet, 3.5),
      (Offset(size.width * 0.08, size.height * 0.58), AppColors.indigo, 3),
      (Offset(size.width * 0.34, size.height * 0.82), AppColors.orange, 4),
      (Offset(size.width * 0.56, size.height * 0.90), AppColors.violet, 2.5),
    ];

    for (final (offset, color, radius) in dots) {
      canvas.drawCircle(
        offset,
        radius,
        Paint()..color = color.withValues(alpha: 0.35),
      );
    }
  }

  void _drawWave(Canvas canvas, Size size) {
    final path = Path();
    final startY = size.height * 0.36;
    path.moveTo(size.width * 0.04, startY);
    path.cubicTo(
      size.width * 0.22,
      startY - 18,
      size.width * 0.34,
      startY + 22,
      size.width * 0.52,
      startY,
    );
    path.cubicTo(
      size.width * 0.68,
      startY - 16,
      size.width * 0.82,
      startY + 14,
      size.width * 0.96,
      startY - 4,
    );

    final paint = Paint()
      ..color = AppColors.indigo.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

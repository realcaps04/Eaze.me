import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

/// Soft aurora blobs + vector accents (matches auth screens).
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
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _VectorAccentsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    _drawRing(
      canvas,
      center: Offset(size.width * 0.14, size.height * 0.20),
      radius: 58,
      color: AppColors.indigo.withValues(alpha: 0.38),
      strokeWidth: 2.2,
      startAngle: 0.35,
      sweepAngle: math.pi * 1.4,
    );
    _drawRing(
      canvas,
      center: Offset(size.width * 0.86, size.height * 0.16),
      radius: 48,
      color: AppColors.orange.withValues(alpha: 0.42),
      strokeWidth: 2.0,
      startAngle: math.pi * 0.8,
      sweepAngle: math.pi * 1.15,
    );
    _drawRing(
      canvas,
      center: Offset(size.width * 0.10, size.height * 0.62),
      radius: 72,
      color: AppColors.violet.withValues(alpha: 0.34),
      strokeWidth: 1.8,
      startAngle: math.pi * 1.15,
      sweepAngle: math.pi,
    );
    _drawRing(
      canvas,
      center: Offset(size.width * 0.84, size.height * 0.68),
      radius: 64,
      color: AppColors.indigo.withValues(alpha: 0.30),
      strokeWidth: 1.8,
      startAngle: math.pi * 0.2,
      sweepAngle: math.pi * 0.9,
    );

    _drawDiamond(
      canvas,
      center: Offset(size.width * 0.18, size.height * 0.42),
      radius: 22,
      color: AppColors.orange.withValues(alpha: 0.28),
      strokeWidth: 1.8,
    );
    _drawDiamond(
      canvas,
      center: Offset(size.width * 0.82, size.height * 0.44),
      radius: 18,
      color: AppColors.indigo.withValues(alpha: 0.26),
      strokeWidth: 1.6,
    );

    _drawDots(canvas, size);
    _drawWave(canvas, size);
    _drawCross(canvas, Offset(size.width * 0.72, size.height * 0.30), 14,
        AppColors.violet.withValues(alpha: 0.32));
    _drawCross(canvas, Offset(size.width * 0.28, size.height * 0.72), 12,
        AppColors.orange.withValues(alpha: 0.30));
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

  void _drawDiamond(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required Color color,
    required double strokeWidth,
  }) {
    final path = Path()
      ..moveTo(center.dx, center.dy - radius)
      ..lineTo(center.dx + radius, center.dy)
      ..lineTo(center.dx, center.dy + radius)
      ..lineTo(center.dx - radius, center.dy)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _drawCross(Canvas canvas, Offset center, double arm, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx - arm, center.dy),
      Offset(center.dx + arm, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - arm),
      Offset(center.dx, center.dy + arm),
      paint,
    );
  }

  void _drawDots(Canvas canvas, Size size) {
    final dots = <(Offset, Color, double)>[
      (Offset(size.width * 0.24, size.height * 0.12), AppColors.orange, 5),
      (Offset(size.width * 0.64, size.height * 0.09), AppColors.indigo, 4),
      (Offset(size.width * 0.90, size.height * 0.38), AppColors.violet, 4.5),
      (Offset(size.width * 0.06, size.height * 0.48), AppColors.indigo, 4),
      (Offset(size.width * 0.32, size.height * 0.84), AppColors.orange, 5),
      (Offset(size.width * 0.58, size.height * 0.88), AppColors.violet, 3.5),
      (Offset(size.width * 0.50, size.height * 0.22), AppColors.indigo, 3),
    ];

    for (final (offset, color, radius) in dots) {
      canvas.drawCircle(
        offset,
        radius,
        Paint()..color = color.withValues(alpha: 0.55),
      );
      canvas.drawCircle(
        offset,
        radius + 3,
        Paint()
          ..color = color.withValues(alpha: 0.18)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
    }
  }

  void _drawWave(Canvas canvas, Size size) {
    final path = Path();
    final startY = size.height * 0.34;
    path.moveTo(size.width * 0.02, startY);
    path.cubicTo(
      size.width * 0.20,
      startY - 24,
      size.width * 0.36,
      startY + 28,
      size.width * 0.54,
      startY,
    );
    path.cubicTo(
      size.width * 0.70,
      startY - 20,
      size.width * 0.84,
      startY + 18,
      size.width * 0.98,
      startY - 6,
    );

    final paint = Paint()
      ..color = AppColors.indigo.withValues(alpha: 0.26)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

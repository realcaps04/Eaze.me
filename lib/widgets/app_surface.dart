import 'package:flutter/material.dart';

class AppSurface extends StatelessWidget {
  const AppSurface({
    super.key,
    required this.child,
    this.padding,
    this.radius = 24,
    this.backgroundColor,
    this.gradient,
    this.border = true,
  });

  final Widget child;
  final EdgeInsets? padding;
  final double radius;
  final Color? backgroundColor;
  final Gradient? gradient;
  final bool border;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? (backgroundColor ?? Colors.white) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        border: border
            ? Border.all(color: cs.outlineVariant.withValues(alpha: 0.55))
            : null,
      ),
      child: child,
    );
  }
}


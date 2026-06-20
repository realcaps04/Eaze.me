import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 56});

  final double size;

  static const _assetPath = 'assets/images/eazeme_logo.png';

  @override
  Widget build(BuildContext context) {
    final radius = size * 0.286;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.indigo.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(
          _assetPath,
          fit: BoxFit.cover,
          width: size,
          height: size,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AppColors {
  // Inspired by the reference (premium indigo + warm accent).
  static const indigo = Color(0xFF261AF6);
  static const violet = Color(0xFF6D5EF7);
  static const orange = Color(0xFFFE6839);

  // Soft lavender canvas background.
  static const canvas = Color(0xFFF3F0FF);
  static const surface = Colors.white;

  static LinearGradient brandGradient() {
    return const LinearGradient(
      colors: [indigo, violet],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Warm accent gradient (orange -> indigo), mirrors the reference slider.
  static LinearGradient accentGradient() {
    return const LinearGradient(
      colors: [orange, indigo],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
  }
}


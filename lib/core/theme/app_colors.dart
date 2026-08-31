import 'package:flutter/material.dart';

/// Central color palette for Nepali Kids LMS
/// Child-friendly, functional, and consistent across the app.
class AppColors {
  AppColors._(); // Prevent instantiation

  // ─── Core Brand Colors ───────────────────────────────────────────
  static const Color primary = Color(0xFF4AA9E8); // Friendly sky blue
  static const Color secondary = Color(0xFFFFD45A); // Cheerful yellow
  static const Color accent = Color(0xFFFF7B54); // Playful orange
  static const Color success = Color(0xFF65C878); // Soft green
  static const Color background = Color(0xFFF7FBFF); // Very light blue-white
  static const Color textDark = Color(0xFF26364A); // Dark blue-gray

  static const Color white = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFE57373);
  static const Color inputFill = Color(0xFFEBF5FE);
  static const Color cardShadow = Color(0x1A4AA9E8);

  // ─── Gradient colors ─────────────────────────────────────────────
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4AA9E8), Color(0xFF2E86C1)],
  );

  static const LinearGradient loginGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFEBF5FE), Color(0xFFF7FBFF)],
  );

  // ─── Feature / Function Colors ───────────────────────────────────
  /// 🏠 Home → Blue
  static const Color home = Color(0xFF4AA9E8);

  /// 📚 Lessons → Purple/Blue
  static const Color lessons = Color(0xFF7E57C2);

  /// 🎮 Games → Orange
  static const Color games = Color(0xFFFF7B54);

  /// ⭐ Rewards → Yellow
  static const Color rewards = Color(0xFFFFD45A);

  /// 🏆 Achievements → Green
  static const Color achievements = Color(0xFF65C878);

  /// 📖 Stories → Pink/Purple
  static const Color stories = Color(0xFFEC407A);

  /// 🔊 Audio → Teal
  static const Color audio = Color(0xFF26A69A);
}

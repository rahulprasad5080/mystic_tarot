import 'package:flutter/material.dart';

/// Light "white & sky blue" palette for the Tarot app.
/// Crisp white surfaces, sky-blue accents, and deep-slate text
/// create a fresh, airy, premium feel.
class AppColors {
  AppColors._();

  // Primary palette — Sky Blue
  static const Color primaryBlue = Color(0xFF0EA5E9);
  static const Color primaryBlueLight = Color(0xFF7DD3FC);
  static const Color primaryBlueDark = Color(0xFF0284C7);

  // Accent palette — Deep Sky (CTAs & highlights)
  static const Color accentBlue = Color(0xFF0284C7);
  static const Color accentBlueLight = Color(0xFF38BDF8);
  static const Color accentBlueDark = Color(0xFF075985);

  // Accent — Cyan
  static const Color celestialBlue = Color(0xFF22D3EE);
  static const Color celestialBlueDark = Color(0xFF0891B2);

  // Backgrounds — White & soft sky tints
  static const Color background = Color(0xFFF0F9FF); // sky-50
  static const Color surface = Color(0xFFFFFFFF); // white cards
  static const Color surfaceGlass = Color(0xB3FFFFFF); // frosted white
  static const Color backgroundCard = Color(0xFFFFFFFF);
  static const Color backgroundCardLight = Color(0xFFDBEAFE); // blue-100

  // Text — Deep slate/navy
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // On-accent text (white on sky-blue buttons)
  static const Color onAccent = Color(0xFFFFFFFF);

  // Gradients
  static const List<Color> backgroundGradient = [
    Color(0xFFBAE6FD), // sky-200
    Color(0xFFE0F2FE), // sky-100
    Color(0xFFF0F9FF), // sky-50
  ];

  static const List<Color> cardGradient = [
    Color(0xFFFFFFFF),
    Color(0xFFF0F9FF),
  ];

  static const List<Color> accentGradient = [
    Color(0xFF38BDF8), // sky-400
    Color(0xFF0EA5E9), // sky-500
    Color(0xFF0369A1), // sky-700
  ];

  static const List<Color> blueGradient = [
    Color(0xFF38BDF8),
    Color(0xFF0EA5E9),
  ];

  // Category colors for reading cards
  static const Color categoryTarot = Color(0xFF0EA5E9);
  static const Color categoryLove = Color(0xFFEC4899);
  static const Color categoryLife = Color(0xFF10B981);
  static const Color categoryHoroscope = Color(0xFFF59E0B);
  static const Color categorySpirituality = Color(0xFF6366F1);

  // Gold & Cosmic dark palette tokens
  static const Color gold = Color(0xFFF59E0B);
  static const Color primaryGold = Color(0xFFD97706);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color surfaceLight = Color(0xFF334155);
  static const Color cardDark = Color(0xFF1E293B);
  static const Color textLight = Color(0xFFF8FAFC);

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}


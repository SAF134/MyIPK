import 'package:flutter/material.dart';

/// MyIPK Design System — Color Tokens
///
/// Built from the Stitch design system with a "paper-like warmth"
/// palette combining bold academic crimson with a calming cream canvas.
class AppColors {
  AppColors._();

  // ── Brand ────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF84006F);
  static const Color primaryContainer = Color(0xFFAB1090);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFFFC7E9);
  static const Color inversePrimary = Color(0xFFFFADE3);

  // ── Secondary ────────────────────────────────────────────────────────
  static const Color secondary = Color(0xFF645F43);
  static const Color secondaryContainer = Color(0xFFE8E0BD);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF686347);
  static const Color secondaryFixed = Color(0xFFEBE3C0);
  static const Color secondaryFixedDim = Color(0xFFCEC7A5);
  static const Color onSecondaryFixed = Color(0xFF1F1C06);
  static const Color onSecondaryFixedVariant = Color(0xFF4B472D);

  // ── Tertiary ─────────────────────────────────────────────────────────
  static const Color tertiary = Color(0xFF454647);
  static const Color tertiaryContainer = Color(0xFF5C5E5E);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFFD7D7D8);

  // ── Error ────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF93000A);

  // ── Surface / Background ─────────────────────────────────────────────
  static const Color surface = Color(0xFFFCF9F8);
  static const Color surfaceDim = Color(0xFFDCD9D9);
  static const Color surfaceBright = Color(0xFFFCF9F8);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF6F3F2);
  static const Color surfaceContainer = Color(0xFFF0EDED);
  static const Color surfaceContainerHigh = Color(0xFFEAE7E7);
  static const Color surfaceContainerHighest = Color(0xFFE5E2E1);
  static const Color onSurface = Color(0xFF1C1B1B);
  static const Color onSurfaceVariant = Color(0xFF55414D);
  static const Color inverseSurface = Color(0xFF313030);
  static const Color inverseOnSurface = Color(0xFFF3F0EF);
  static const Color surfaceTint = Color(0xFFAC1291);
  static const Color background = Color(0xFFFCF9F8);
  static const Color onBackground = Color(0xFF1C1B1B);

  // ── Cream Background (from style guidance) ───────────────────────────
  static const Color creamBackground = Color(0xFFFFF7D3);

  // ── Outline ──────────────────────────────────────────────────────────
  static const Color outline = Color(0xFF87717E);
  static const Color outlineVariant = Color(0xFFDABFCE);

  // ── Primary Fixed ────────────────────────────────────────────────────
  static const Color primaryFixed = Color(0xFFFFD8EE);
  static const Color primaryFixedDim = Color(0xFFFFADE3);
  static const Color onPrimaryFixed = Color(0xFF3A0030);
  static const Color onPrimaryFixedVariant = Color(0xFF860070);

  // ── Tertiary Fixed ───────────────────────────────────────────────────
  static const Color tertiaryFixed = Color(0xFFE2E2E2);
  static const Color tertiaryFixedDim = Color(0xFFC6C6C7);

  // ── Custom (from style guidance) ─────────────────────────────────────
  static const Color cardBorder = Color(0xFFE6DEBC);
  static const Color surfaceVariant = Color(0xFFE5E2E1);

  static Color getGradeColor(String grade) {
    switch (grade) {
      case 'A':
        return const Color(0xFF2E7D32);
      case 'AB':
        return const Color(0xFF4CAF50);
      case 'B':
        return const Color(0xFF8BC34A);
      case 'BC':
        return const Color(0xFFFBC02D);
      case 'C':
        return const Color(0xFFF57C00);
      case 'D':
        return const Color(0xFFE64A19);
      case 'E':
        return const Color(0xFFD32F2F);
      default:
        return Colors.grey;
    }
  }
}

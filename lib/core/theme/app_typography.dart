import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// MyIPK Design System — Typography Tokens
///
/// Heading hierarchy uses **Plus Jakarta Sans** for a friendly, modern feel.
/// Body & labels use **Inter** for functional clarity at small sizes.
class AppTypography {
  AppTypography._();

  // ── Display ──────────────────────────────────────────────────────────
  static TextStyle displayLarge = GoogleFonts.plusJakartaSans(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 56 / 48,
    letterSpacing: -0.02 * 48,
  );

  // ── Headline ─────────────────────────────────────────────────────────
  static TextStyle headlineLarge = GoogleFonts.plusJakartaSans(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
  );

  static TextStyle headlineLargeMobile = GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
  );

  static TextStyle headlineMedium = GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
  );

  // ── Title ────────────────────────────────────────────────────────────
  static TextStyle titleLarge = GoogleFonts.plusJakartaSans(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
  );

  // ── Body ─────────────────────────────────────────────────────────────
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  // ── Label ────────────────────────────────────────────────────────────
  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: 0.01 * 14,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.05 * 12,
  );
}

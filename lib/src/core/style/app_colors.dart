import 'package:flutter/material.dart';

/// Central color palette derived from the design.
///
/// Nothing in the UI layer should hardcode a [Color]; everything resolves
/// through this class (or the [ThemeData] built from it).
class AppColors {
  AppColors._();

  // ── Brand palette (named swatches) ──────────────────────────────
  static const Color mint = Color(0xFFAAD7CD);
  static const Color ivory = Color(0xFFFAFAEB);
  static const Color scarlet = Color(0xFFF02300);
  static const Color scarletDark = Color(0xFFC81C00); // derived gradient end

  // ── Semantic roles (UI references these, not raw swatches) ──────
  // Surfaces
  static const Color background = ivory; // page background
  static const Color surface = Color(0xFFFFFFFF);
  static const Color accent = mint;

  // Brand
  static const Color brandRed = scarlet; // gradient start
  static const Color brandRedDark = scarletDark; // gradient end

  /// Header / primary-button gradient (CSS `linear-gradient(160deg, …)`).
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment(-0.2, -1.0),
    end: Alignment(0.2, 1.0),
    colors: [brandRed, brandRedDark],
  );

  // Text
  static const Color textPrimary = Color(0xFF12263A); // dark navy headings
  static const Color textSecondary = Color(0xFF6B7280); // muted subtitle
  static const Color label = Color(0xFF64748B); // uppercase field labels
  static const Color hint = Color(0xFF9CA3AF);
  static const Color onBrand = Color(0xFFFFFFFF);

  // Controls
  static const Color toggleTrack = Color(0xFFEDEEE4);
  static const Color fieldBorder = Color(0xFFE5E7EB);
  static const Color fieldFill = Color(0xFFFFFFFF);
  static const Color iconMuted = Color(0xFF9AA5B1);

  // Status
  static const Color error = Color(0xFFD92D20);
  static const Color success = Color(0xFF12B76A);
}

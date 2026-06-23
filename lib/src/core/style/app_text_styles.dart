import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typographic scale. UI widgets reference these instead of building
/// [TextStyle]s inline.
class AppTextStyles {
  AppTextStyles._();

  // Brand header — matches `font-weight:900; font-size:28px; letter-spacing:8px`.
  // NOTE: design uses the "Catamaran" font; add it under `flutter > fonts`
  // and set `fontFamily: 'Catamaran'` here for an exact match.
  static const TextStyle wordmark = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    letterSpacing: 8,
    color: AppColors.onBrand,
    height: 1.0,
  );

  // `text-white/70`
  static final TextStyle tagline = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.onBrand.withValues(alpha: 0.70),
  );

  // Body
  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle fieldLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    color: AppColors.label,
  );

  static const TextStyle input = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle hint = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.hint,
  );

  static const TextStyle toggleSelected = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle toggleUnselected = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static const TextStyle link = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.brandRed,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.onBrand,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
}

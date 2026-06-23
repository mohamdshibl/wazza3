import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Builds the global [ThemeData] from the design tokens.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.brandRed,
      primary: AppColors.brandRed,
      surface: AppColors.surface,
      error: AppColors.error,
    );

    // Catamaran is bundled locally (assets/fonts) and set as the default
    // family, so every Text inherits it — no runtime network fetch.
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: AppFontFamily.catamaran,
      scaffoldBackgroundColor: AppColors.background,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}

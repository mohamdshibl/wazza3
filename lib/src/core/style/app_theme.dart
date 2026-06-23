import 'package:flutter/material.dart';

import 'app_colors.dart';

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

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}

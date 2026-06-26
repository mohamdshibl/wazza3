import 'package:flutter/material.dart';

import 'app_colors.dart';

/// The app font family. Bundled locally under `assets/fonts` and declared
/// in `pubspec.yaml` (no runtime download).
class AppFontFamily {
  AppFontFamily._();
  static const String catamaran = 'Catamaran';
}

/// Typographic scale. UI widgets reference these instead of building
/// [TextStyle]s inline. Every style pins [AppFontFamily.catamaran] so the
/// font is guaranteed regardless of the inherited default.
class AppTextStyles {
  AppTextStyles._();

  static const String _family = AppFontFamily.catamaran;

  // Brand header — `font-weight:900; font-size:28px; letter-spacing:8px`.
  static const TextStyle wordmark = TextStyle(
    fontFamily: _family,
    fontSize: 28,
    fontWeight: FontWeight.w900,
    letterSpacing: 8,
    color: AppColors.onBrand,
    height: 1.0,
  );

  // `text-white/70`
  static final TextStyle tagline = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.onBrand.withValues(alpha: 0.70),
  );

  // Body
  static const TextStyle heading = TextStyle(
    fontFamily: _family,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle fieldLabel = TextStyle(
    fontFamily: _family,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    color: AppColors.label,
  );

  static const TextStyle input = TextStyle(
    fontFamily: _family,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle hint = TextStyle(
    fontFamily: _family,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.hint,
  );

  static const TextStyle toggleSelected = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle toggleUnselected = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static const TextStyle link = TextStyle(
    fontFamily: _family,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.brandRed,
  );

  static const TextStyle button = TextStyle(
    fontFamily: _family,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.onBrand,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _family,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
}

InlineSpan buildCurrencyTextSpan(String text, TextStyle style) {
  final List<TextSpan> spans = [];
  final RegExp regExp = RegExp(r'(\$)');
  final matches = regExp.allMatches(text);

  int lastIndex = 0;
  for (final match in matches) {
    if (match.start > lastIndex) {
      spans.add(TextSpan(
        text: text.substring(lastIndex, match.start),
        style: style,
      ));
    }
    spans.add(TextSpan(
      text: '\$',
      style: style.copyWith(fontFamily: 'sans-serif'),
    ));
    lastIndex = match.end;
  }
  if (lastIndex < text.length) {
    spans.add(TextSpan(
      text: text.substring(lastIndex),
      style: style,
    ));
  }

  return TextSpan(children: spans);
}

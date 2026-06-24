import 'package:wazza3/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../core/style/app_spacing.dart';
import '../../../../core/style/app_text_styles.dart';
import 'brand_logo_mark.dart';

/// Foreground brand block: vector mark + wordmark + tagline.
///
/// Pure presentation, no state — kept separate from the header so it can be
/// reused (splash, drawer, about screen…).
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const BrandLogoMark(),
        const SizedBox(height: AppSpacing.lg), // mb-4
        Text(AppLocalizations.of(context)!.appName, style: AppTextStyles.wordmark),
        const SizedBox(height: AppSpacing.xs), // mt-1
        Text(AppLocalizations.of(context)!.tagline, style: AppTextStyles.tagline),
      ],
    );
  }
}

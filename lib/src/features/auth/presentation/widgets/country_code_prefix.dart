import 'package:flutter/material.dart';

import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_spacing.dart';
import '../../../../core/style/app_text_styles.dart';
import '../../data/models/country.dart';

/// Leading prefix for the phone field: tappable country code
/// (`SA +966`), a divider, then a phone glyph. Used as `customPrefix`
/// inside [AppTextField].
class CountryCodePrefix extends StatelessWidget {
  const CountryCodePrefix({
    super.key,
    required this.country,
    required this.onTap,
  });

  final Country country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  country.isoCode,
                  style: AppTextStyles.input.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(country.dialCode, style: AppTextStyles.input),
              ],
            ),
          ),
        ),
        Container(width: 1, height: 24, color: AppColors.fieldBorder),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Icon(Icons.phone_outlined, color: AppColors.iconMuted, size: 20),
        ),
      ],
    );
  }
}

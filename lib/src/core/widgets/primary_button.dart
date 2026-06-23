import 'package:flutter/material.dart';

import '../style/app_colors.dart';
import '../style/app_radii.dart';
import '../style/app_spacing.dart';
import '../style/app_text_styles.dart';

/// Full-width gradient CTA with an optional trailing icon inside a
/// translucent circle. Shows a spinner while [isLoading].
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.trailingIcon,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? trailingIcon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null && !isLoading;

    return Opacity(
      opacity: enabled ? 1 : 0.7,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.brandGradient,
          borderRadius: AppRadii.button,
          boxShadow: [
            BoxShadow(
              color: AppColors.brandRed.withValues(alpha: 0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppRadii.button,
            onTap: enabled ? onPressed : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: isLoading
                  ? const _Spinner()
                  : _Content(label: label, trailingIcon: trailingIcon),
            ),
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.label, this.trailingIcon});

  final String label;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: AppTextStyles.button),
        if (trailingIcon != null) ...[
          const SizedBox(width: AppSpacing.md),
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: AppColors.onBrand.withValues(alpha: 0.22),
              shape: BoxShape.circle,
            ),
            child: Icon(trailingIcon, size: 16, color: AppColors.onBrand),
          ),
        ],
      ],
    );
  }
}

class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 22,
      width: 22,
      child: Center(
        child: SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            valueColor: AlwaysStoppedAnimation(AppColors.onBrand),
          ),
        ),
      ),
    );
  }
}

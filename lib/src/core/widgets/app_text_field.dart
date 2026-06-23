import 'package:flutter/material.dart';

import '../style/app_colors.dart';
import '../style/app_radii.dart';
import '../style/app_spacing.dart';
import '../style/app_text_styles.dart';

/// A labeled text field matching the design: uppercase label above a
/// rounded white field with a leading icon and optional trailing widget.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.customPrefix,
    this.helperText,
    this.controller,
    this.suffix,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.textInputAction,
    this.onSubmitted,
  }) : assert(
          prefixIcon != null || customPrefix != null,
          'Provide either a prefixIcon or a customPrefix.',
        );

  final String label;
  final String hint;

  /// Simple leading icon. Ignored when [customPrefix] is supplied.
  final IconData? prefixIcon;

  /// Rich leading widget (e.g. a country-code selector) that replaces
  /// [prefixIcon].
  final Widget? customPrefix;

  /// Optional muted helper line shown beneath the field.
  final String? helperText;

  final TextEditingController? controller;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.fieldLabel),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          textInputAction: textInputAction,
          onFieldSubmitted: onSubmitted,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: AppTextStyles.input,
          cursorColor: AppColors.brandRed,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.hint,
            helperText: helperText,
            helperStyle: AppTextStyles.caption,
            filled: true,
            fillColor: AppColors.fieldFill,
            prefixIcon: customPrefix ??
                Icon(prefixIcon, color: AppColors.iconMuted, size: 20),
            prefixIconConstraints: customPrefix != null
                ? const BoxConstraints(minWidth: 0, minHeight: 0)
                : null,
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(
              vertical: AppSpacing.lg,
              horizontal: AppSpacing.lg,
            ),
            enabledBorder: _border(AppColors.fieldBorder),
            focusedBorder: _border(AppColors.brandRed, width: 1.4),
            errorBorder: _border(AppColors.error),
            focusedErrorBorder: _border(AppColors.error, width: 1.4),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: AppRadii.field,
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

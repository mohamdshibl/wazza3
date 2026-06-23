import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/style/app_radii.dart';
import '../../../../core/style/app_spacing.dart';
import '../../../../core/style/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/country.dart';
import '../../logic/controllers/sign_in_controller.dart';
import 'country_code_prefix.dart';

/// Mobile-number field with a country-code selector prefix and OTP helper
/// text. Reads/writes the selected [Country] through the controller.
class PhoneNumberField extends ConsumerWidget {
  const PhoneNumberField({
    super.key,
    required this.controller,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final country = ref.watch(
      signInControllerProvider.select((s) => s.country),
    );

    return AppTextField(
      controller: controller,
      label: AppStrings.mobileNumberLabel,
      hint: AppStrings.mobileNumberHint,
      helperText: AppStrings.otpHelper,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      validator: Validators.phone,
      onSubmitted: onSubmitted,
      customPrefix: CountryCodePrefix(
        country: country,
        onTap: () => _pickCountry(context, ref),
      ),
    );
  }

  Future<void> _pickCountry(BuildContext context, WidgetRef ref) async {
    final selected = await showModalBottomSheet<Country>(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: AppRadii.field),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final c in Countries.all)
              ListTile(
                leading: Text(c.isoCode, style: AppTextStyles.toggleSelected),
                title: Text(c.dialCode, style: AppTextStyles.input),
                onTap: () => Navigator.of(context).pop(c),
              ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );

    if (selected != null) {
      ref.read(signInControllerProvider.notifier).selectCountry(selected);
    }
  }
}

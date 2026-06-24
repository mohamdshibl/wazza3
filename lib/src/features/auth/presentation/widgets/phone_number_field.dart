import 'package:wazza3/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/style/app_radii.dart';
import '../../../../core/style/app_spacing.dart';
import '../../../../core/style/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/country.dart';
import '../../logic/controllers/sign_in_cubit.dart';
import 'country_code_prefix.dart';

/// Mobile-number field with a country-code selector prefix and OTP helper
/// text. Reads/writes the selected Country through the Cubit.
class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({
    super.key,
    required this.controller,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final country = context.watch<SignInCubit>().state.country;

    return AppTextField(
      controller: controller,
      label: AppLocalizations.of(context)!.mobileNumberLabel,
      hint: AppLocalizations.of(context)!.mobileNumberHint,
      helperText: AppLocalizations.of(context)!.otpHelper,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      onSubmitted: onSubmitted,
      customPrefix: CountryCodePrefix(
        country: country,
        onTap: () => _pickCountry(context),
      ),
    );
  }

  Future<void> _pickCountry(BuildContext context) async {
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

    if (selected != null && context.mounted) {
      context.read<SignInCubit>().selectCountry(selected);
    }
  }
}

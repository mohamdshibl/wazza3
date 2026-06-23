import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/style/app_text_styles.dart';
import '../../data/models/auth_method.dart';
import '../../logic/controllers/sign_in_cubit.dart';

/// Legal notice below the CTA. Copy depends on the active auth method:
/// "By signing in…" (email) vs "By continuing…" (phone/OTP).
class TermsFooter extends StatelessWidget {
  const TermsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isEmail = context.watch<SignInCubit>().state.method == AuthMethod.email;

    return Text(
      isEmail ? AppStrings.termsSignIn : AppStrings.termsContinue,
      textAlign: TextAlign.center,
      style: AppTextStyles.caption,
    );
  }
}

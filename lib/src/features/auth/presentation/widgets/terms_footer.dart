import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/style/app_text_styles.dart';
import '../../data/models/auth_method.dart';
import '../../logic/controllers/sign_in_controller.dart';

/// Legal notice below the CTA. Copy depends on the active auth method:
/// "By signing in…" (email) vs "By continuing…" (phone/OTP).
class TermsFooter extends ConsumerWidget {
  const TermsFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEmail = ref.watch(
      signInControllerProvider.select((s) => s.method == AuthMethod.email),
    );

    return Text(
      isEmail ? AppStrings.termsSignIn : AppStrings.termsContinue,
      textAlign: TextAlign.center,
      style: AppTextStyles.caption,
    );
  }
}

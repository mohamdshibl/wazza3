import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/style/app_text_styles.dart';

/// Centered "By signing in…" notice below the CTA.
class TermsFooter extends StatelessWidget {
  const TermsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.termsNotice,
      textAlign: TextAlign.center,
      style: AppTextStyles.caption,
    );
  }
}

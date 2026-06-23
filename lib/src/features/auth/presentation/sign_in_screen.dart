import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/style/app_spacing.dart';
import '../../../core/style/app_text_styles.dart';
import 'widgets/sign_in_form.dart';
import 'widgets/sign_in_header.dart';
import 'widgets/terms_footer.dart';

/// Sign-in screen. Composes the header + scrollable form body.
///
/// Layout mirrors the design's `min-h-dvh flex flex-col`: a fixed-aspect
/// gradient header followed by a flexible body that scrolls when the
/// keyboard appears or on small screens. Content is centered and width-
/// capped on tablets for a clean responsive result.
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  static const double _maxContentWidth = 480;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: _maxContentWidth),
                    child: const _SignInContent(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SignInContent extends StatelessWidget {
  const _SignInContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SignInHeader(),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xxl,
            AppSpacing.xxxl,
            AppSpacing.xxl,
            AppSpacing.giant,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.signInTitle, style: AppTextStyles.heading),
              const SizedBox(height: AppSpacing.xs),
              Text(AppStrings.signInSubtitle, style: AppTextStyles.subtitle),
              const SizedBox(height: AppSpacing.xxxl),
              const SignInForm(),
              const SizedBox(height: AppSpacing.xxl),
              const Center(child: TermsFooter()),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/request_status.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_spacing.dart';
import '../../../../core/style/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/models/auth_method.dart';
import '../../logic/controllers/sign_in_controller.dart';
import '../../logic/controllers/sign_in_state.dart';
import 'auth_method_toggle.dart';

/// The interactive sign-in form. Holds the text controllers and form key
/// (transient view state); all business logic is delegated to
/// [SignInController].
class SignInForm extends ConsumerStatefulWidget {
  const SignInForm({super.key});

  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    ref.read(signInControllerProvider.notifier).signIn(
          identifier: _identifierController.text,
          password: _passwordController.text,
        );
  }

  void _handleStatusChange(SignInState? prev, SignInState next) {
    if (prev?.status == next.status) return;
    final messenger = ScaffoldMessenger.of(context);

    if (next.status.isFailure) {
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(next.errorMessage ?? AppStrings.genericError),
        ),
      );
      ref.read(signInControllerProvider.notifier).acknowledgeError();
    } else if (next.status.isSuccess) {
      messenger.showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.success,
          content: Text('Signed in successfully'),
        ),
      );
      // TODO: navigate to the home/dashboard route once it exists.
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signInControllerProvider, _handleStatusChange);

    final state = ref.watch(signInControllerProvider);
    final isEmail = state.method == AuthMethod.email;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthMethodToggle(),
          const SizedBox(height: AppSpacing.xxl),
          AppTextField(
            controller: _identifierController,
            label: isEmail ? AppStrings.emailLabel : AppStrings.phoneLabel,
            hint: isEmail ? AppStrings.emailHint : AppStrings.phoneHint,
            prefixIcon: isEmail ? Icons.mail_outline : Icons.phone_outlined,
            keyboardType:
                isEmail ? TextInputType.emailAddress : TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: isEmail ? Validators.email : Validators.phone,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppTextField(
            controller: _passwordController,
            label: AppStrings.passwordLabel,
            hint: AppStrings.passwordHint,
            prefixIcon: Icons.lock_outline,
            obscureText: state.obscurePassword,
            validator: Validators.password,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            suffix: IconButton(
              onPressed: ref
                  .read(signInControllerProvider.notifier)
                  .togglePasswordVisibility,
              icon: Icon(
                state.obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.iconMuted,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {/* TODO: forgot-password flow */},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                AppStrings.forgotPassword,
                style: AppTextStyles.link,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          PrimaryButton(
            label: AppStrings.signInCta,
            trailingIcon: Icons.arrow_forward,
            isLoading: state.status.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

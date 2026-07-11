import 'package:wazza3/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/request_status.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_spacing.dart';
import '../../../../core/style/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/routing/app_routes.dart';
import '../../data/models/auth_method.dart';
import '../../logic/controllers/sign_in_cubit.dart';
import '../../logic/controllers/sign_in_state.dart';
import 'auth_method_toggle.dart';
import 'phone_number_field.dart';

/// The interactive sign-in form. Holds the text controllers and form key.
class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<SignInCubit>();
    final method = cubit.state.method;

    if (method == AuthMethod.email) {
      cubit.signIn(
        identifier: _emailController.text,
        password: _passwordController.text,
      );
    } else {
      cubit.requestOtp(number: _phoneController.text);
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 8,
          backgroundColor: AppColors.surface,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.error,
                    size: 36,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  AppLocalizations.of(context)!.invalidCredentialsTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subtitle.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandRed,
                      foregroundColor: AppColors.onBrand,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.tryAgain,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleStatusChange(BuildContext context, SignInState state) {
    if (state.status.isFailure) {
      _showErrorDialog(
        context,
        state.errorMessage ?? AppLocalizations.of(context)!.genericError,
      );
      context.read<SignInCubit>().acknowledgeError();
    } else if (state.status.isSuccess) {
      final messenger = ScaffoldMessenger.of(context);
      final isOtp = state.method == AuthMethod.phone;
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.success,
          content: Text(isOtp ? 'OTP sent to your number' : 'Signed in successfully'),
        ),
      );
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.sessionStart,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInCubit, SignInState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: _handleStatusChange,
      child: BlocBuilder<SignInCubit, SignInState>(
        builder: (context, state) {
          final isEmail = state.method == AuthMethod.email;
          final isLoading = state.status.isLoading;

          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AuthMethodToggle(),
                const SizedBox(height: AppSpacing.xxl),
                if (isEmail) ..._emailFields(state.obscurePassword) else _phoneField(),
                const SizedBox(height: AppSpacing.xxxl),
                PrimaryButton(
                  label: isEmail ? AppLocalizations.of(context)!.signInCta : AppLocalizations.of(context)!.sendOtpCta,
                  trailingIcon: Icons.arrow_forward,
                  isLoading: isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _emailFields(bool obscure) {
    return [
      AppTextField(
        controller: _emailController,
        label: AppLocalizations.of(context)!.emailLabel,
        hint: AppLocalizations.of(context)!.emailHint,
        prefixIcon: Icons.mail_outline,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        validator: (v) {
          if (v == null || v.trim().isEmpty) {
            return 'Username or Email is required';
          }
          return null;
        },
      ),
      const SizedBox(height: AppSpacing.xl),
      AppTextField(
        controller: _passwordController,
        label: AppLocalizations.of(context)!.passwordLabel,
        hint: AppLocalizations.of(context)!.passwordHint,
        prefixIcon: Icons.lock_outline,
        obscureText: obscure,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
        validator: (v) => Validators.password(context, v),
        suffix: IconButton(
          onPressed: () => context.read<SignInCubit>().togglePasswordVisibility(),
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: AppColors.iconMuted,
            size: 20,
          ),
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(AppRoutes.resetPassword),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(AppLocalizations.of(context)!.forgotPassword, style: AppTextStyles.link),
        ),
      ),
    ];
  }

  Widget _phoneField() {
    return PhoneNumberField(
      controller: _phoneController,
      onSubmitted: (_) => _submit(),
    );
  }
}

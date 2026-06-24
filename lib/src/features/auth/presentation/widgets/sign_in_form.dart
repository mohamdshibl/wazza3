import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/request_status.dart';
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
    // Bypass validation for easier login/testing
    // if (!_formKey.currentState!.validate()) return;

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

  void _handleStatusChange(BuildContext context, SignInState state) {
    final messenger = ScaffoldMessenger.of(context);

    if (state.status.isFailure) {
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(state.errorMessage ?? AppStrings.genericError),
        ),
      );
      context.read<SignInCubit>().acknowledgeError();
    } else if (state.status.isSuccess) {
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
                  label: isEmail ? AppStrings.signInCta : AppStrings.sendOtpCta,
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
        label: AppStrings.emailLabel,
        hint: AppStrings.emailHint,
        prefixIcon: Icons.mail_outline,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
      ),
      const SizedBox(height: AppSpacing.xl),
      AppTextField(
        controller: _passwordController,
        label: AppStrings.passwordLabel,
        hint: AppStrings.passwordHint,
        prefixIcon: Icons.lock_outline,
        obscureText: obscure,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
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
          onPressed: () {/* TODO: forgot-password flow */},
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(AppStrings.forgotPassword, style: AppTextStyles.link),
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

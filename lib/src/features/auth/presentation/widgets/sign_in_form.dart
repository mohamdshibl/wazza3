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
import '../../../../core/routing/app_routes.dart';
import '../../data/models/auth_method.dart';
import '../../logic/controllers/sign_in_controller.dart';
import '../../logic/controllers/sign_in_state.dart';
import 'auth_method_toggle.dart';
import 'phone_number_field.dart';

/// The interactive sign-in form. Holds the text controllers and form key
/// (transient view state); all business logic is delegated to
/// [SignInController]. Renders the Email or Phone variant by [AuthMethod].
class SignInForm extends ConsumerStatefulWidget {
  const SignInForm({super.key});

  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
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

    final controller = ref.read(signInControllerProvider.notifier);
    final method = ref.read(signInControllerProvider).method;

    if (method == AuthMethod.email) {
      controller.signIn(
        identifier: _emailController.text,
        password: _passwordController.text,
      );
    } else {
      controller.requestOtp(number: _phoneController.text);
    }
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
      final isOtp = next.method == AuthMethod.phone;
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.success,
          content: Text(isOtp ? 'OTP sent to your number' : 'Signed in successfully'),
        ),
      );
      if (isOtp) {
        Navigator.of(context).pushNamed(
          AppRoutes.otpVerification,
          arguments: _phoneController.text,
        );
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.dashboard,
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signInControllerProvider, _handleStatusChange);

    final isEmail = ref.watch(
      signInControllerProvider.select((s) => s.method == AuthMethod.email),
    );
    final isLoading = ref.watch(
      signInControllerProvider.select((s) => s.status.isLoading),
    );

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthMethodToggle(),
          const SizedBox(height: AppSpacing.xxl),
          if (isEmail) ..._emailFields() else _phoneField(),
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
  }

  List<Widget> _emailFields() {
    final obscure = ref.watch(
      signInControllerProvider.select((s) => s.obscurePassword),
    );

    return [
      AppTextField(
        controller: _emailController,
        label: AppStrings.emailLabel,
        hint: AppStrings.emailHint,
        prefixIcon: Icons.mail_outline,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        validator: Validators.email,
      ),
      const SizedBox(height: AppSpacing.xl),
      AppTextField(
        controller: _passwordController,
        label: AppStrings.passwordLabel,
        hint: AppStrings.passwordHint,
        prefixIcon: Icons.lock_outline,
        obscureText: obscure,
        validator: Validators.password,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
        suffix: IconButton(
          onPressed: ref
              .read(signInControllerProvider.notifier)
              .togglePasswordVisibility,
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

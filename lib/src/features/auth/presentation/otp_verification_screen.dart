import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/enums/request_status.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/style/app_colors.dart';
import '../../../core/style/app_spacing.dart';
import '../../../core/style/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../logic/controllers/auth_cubit.dart';
import '../logic/controllers/otp_verification_cubit.dart';
import '../logic/controllers/otp_verification_state.dart';
import 'widgets/sign_in_header.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  final String phoneNumber;

  static const double _maxContentWidth = 480;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus the input on screen entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pinFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  void _submitCode(BuildContext context, String code) async {
    if (code.length < 4) return;
    
    final cubit = context.read<OtpVerificationCubit>();
    final user = await cubit.verifyOtp(code);
    
    if (mounted && user != null) {
      if (context.mounted) {
        context.read<AuthCubit>().setUser(user);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.success,
            content: Text('Phone number verified successfully!'),
          ),
        );
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.sessionStart,
          (route) => false,
        );
      }
    }
  }

  void _handleStatusChange(BuildContext context, OtpVerificationState state) {
    if (state.status.isFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: Text(state.errorMessage ?? AppStrings.genericError),
        ),
      );
      context.read<OtpVerificationCubit>().acknowledgeError();
      // Clear pins on failure to let the user re-type
      _pinController.clear();
      _pinFocusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpVerificationCubit(phoneNumber: widget.phoneNumber),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              top: false,
              child: Stack(
                children: [
                  // Scrollable Content
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: constraints.maxHeight),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: OtpVerificationScreen._maxContentWidth),
                              child: BlocListener<OtpVerificationCubit, OtpVerificationState>(
                                listenWhen: (prev, curr) => prev.status != curr.status,
                                listener: _handleStatusChange,
                                child: BlocBuilder<OtpVerificationCubit, OtpVerificationState>(
                                  builder: (context, state) {
                                    final isLoading = state.status.isLoading;

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
                                              const Text(
                                                'Verification',
                                                style: AppTextStyles.heading,
                                              ),
                                              const SizedBox(height: AppSpacing.xs),
                                              Text(
                                                'We sent a 4-digit code to ${widget.phoneNumber}',
                                                style: AppTextStyles.subtitle,
                                              ),
                                              const SizedBox(height: AppSpacing.xxxl),
                                              
                                              // PIN code field
                                              _OtpPinInput(
                                                controller: _pinController,
                                                focusNode: _pinFocusNode,
                                                enabled: !isLoading,
                                                onChanged: (code) {
                                                  if (code.length == 4) {
                                                    _submitCode(context, code);
                                                  }
                                                },
                                              ),
                                              
                                              const SizedBox(height: AppSpacing.xxxl),
                                              
                                              // Resend section
                                              _ResendTimerSection(
                                                countdown: state.countdown,
                                                canResend: state.canResend && !isLoading,
                                                onResend: () {
                                                  _pinController.clear();
                                                  _pinFocusNode.requestFocus();
                                                  context.read<OtpVerificationCubit>().resendOtp();
                                                },
                                              ),
                                              
                                              const SizedBox(height: AppSpacing.xxxl),
                                              
                                              // Submit button
                                              PrimaryButton(
                                                label: 'Verify & Proceed',
                                                trailingIcon: Icons.check_circle_outline,
                                                isLoading: isLoading,
                                                onPressed: _pinController.text.length == 4
                                                    ? () => _submitCode(context, _pinController.text)
                                                    : null,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  // Glassmorphic floating Back Button
                  Positioned(
                    top: MediaQuery.of(context).padding.top + AppSpacing.md,
                    left: AppSpacing.lg,
                    child: ClipOval(
                      child: Material(
                        color: AppColors.onBrand.withValues(alpha: 0.15),
                        child: InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            Navigator.of(context).pop();
                          },
                          child: SizedBox(
                            width: 44,
                            height: 44,
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                              color: AppColors.onBrand,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}

class _OtpPinInput extends StatefulWidget {
  const _OtpPinInput({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final ValueChanged<String> onChanged;

  @override
  State<_OtpPinInput> createState() => _OtpPinInputState();
}

class _OtpPinInputState extends State<_OtpPinInput> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = widget.focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.enabled
          ? () => widget.focusNode.requestFocus()
          : null,
      child: Stack(
        children: [
          // Completely hidden native text field to receive inputs/actions
          Opacity(
            opacity: 0,
            child: SizedBox(
              width: 0,
              height: 0,
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                keyboardType: TextInputType.number,
                maxLength: 4,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (text) {
                  setState(() {});
                  widget.onChanged(text);
                },
                enabled: widget.enabled,
                showCursor: false,
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          
          // Custom Styled Boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (index) {
              final text = widget.controller.text;
              final isDigitEntered = text.length > index;
              final digit = isDigitEntered ? text[index] : '';
              
              // Box states
              final isCurrentActive = _isFocused && text.length == index;
              
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: index == 0 ? 0 : AppSpacing.sm,
                    right: index == 3 ? 0 : AppSpacing.sm,
                  ),
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCurrentActive
                          ? AppColors.brandRed
                          : (isDigitEntered ? AppColors.textPrimary : AppColors.fieldBorder),
                      width: isCurrentActive ? 2 : 1.5,
                    ),
                    boxShadow: isCurrentActive
                        ? [
                            BoxShadow(
                              color: AppColors.brandRed.withValues(alpha: 0.15),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Text(
                      digit,
                      key: ValueKey<String>('${digit}_$index'),
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _ResendTimerSection extends StatelessWidget {
  const _ResendTimerSection({
    required this.countdown,
    required this.canResend,
    required this.onResend,
  });

  final int countdown;
  final bool canResend;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    if (canResend) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Didn't receive the code? ",
            style: AppTextStyles.caption,
          ),
          TextButton(
            onPressed: onResend,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Resend Code',
              style: AppTextStyles.link,
            ),
          ),
        ],
      );
    }

    final minutes = (countdown ~/ 60).toString().padLeft(1, '0');
    final seconds = (countdown % 60).toString().padLeft(2, '0');

    return Center(
      child: Text(
        'Resend code in $minutes:$seconds',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

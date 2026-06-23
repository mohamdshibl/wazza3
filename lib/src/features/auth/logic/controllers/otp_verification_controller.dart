import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/request_status.dart';
import '../../data/repos/auth_repository.dart';
import 'auth_controller.dart';
import 'otp_verification_state.dart';

/// Manages OTP verification lifecycle: timer, resend, and code submission.
class OtpVerificationController extends FamilyNotifier<OtpVerificationState, String> {
  Timer? _timer;

  @override
  OtpVerificationState build(String arg) {
    // Start countdown immediately on initialization.
    scheduleMicrotask(startTimer);
    
    // Dispose timer when provider is destroyed.
    ref.onDispose(() {
      _timer?.cancel();
    });
    
    return OtpVerificationState(phoneNumber: arg);
  }

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  void startTimer() {
    _timer?.cancel();
    state = state.copyWith(countdown: 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countdown > 0) {
        state = state.copyWith(countdown: state.countdown - 1);
      } else {
        _timer?.cancel();
      }
    });
  }

  /// Verifies the 4-digit code. Returns true on success, false on failure.
  Future<bool> verifyOtp(String code) async {
    if (state.status.isLoading) return false;
    
    state = state.copyWith(status: RequestStatus.loading, clearError: true);

    final result = await _repository.verifyOtp(
      phoneNumber: state.phoneNumber,
      code: code,
    );

    return switch (result) {
      AuthSuccess(:final user) => () {
          ref.read(currentUserProvider.notifier).state = user;
          return _handleSuccess();
        }(),
      AuthError(:final failure) => _handleFailure(failure.message),
    };
  }

  bool _handleSuccess() {
    state = state.copyWith(status: RequestStatus.success);
    _timer?.cancel();
    return true;
  }

  bool _handleFailure(String message) {
    state = state.copyWith(
      status: RequestStatus.failure,
      errorMessage: message,
    );
    return false;
  }

  /// Resends the OTP and resets the countdown timer.
  Future<void> resendOtp() async {
    if (!state.canResend || state.status.isLoading) return;

    state = state.copyWith(status: RequestStatus.loading, clearError: true);

    final result = await _repository.requestOtp(state.phoneNumber);

    switch (result) {
      case OtpSent():
        state = state.copyWith(status: RequestStatus.idle);
        startTimer();
      case OtpError(:final failure):
        state = state.copyWith(
          status: RequestStatus.failure,
          errorMessage: failure.message,
        );
    }
  }

  /// Acknowledges error state so it can reset to idle.
  void acknowledgeError() {
    if (state.status.isFailure) {
      state = state.copyWith(status: RequestStatus.idle, clearError: true);
    }
  }
}

/// Provider parameterized by the user's phone number.
final otpVerificationControllerProvider =
    NotifierProvider.family<OtpVerificationController, OtpVerificationState, String>(
  OtpVerificationController.new,
);

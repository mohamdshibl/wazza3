import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/request_status.dart';
import '../../data/models/auth_user.dart';
import '../../data/repos/auth_repository.dart';
import 'otp_verification_state.dart';

/// Manages OTP verification lifecycle using Cubit: timer, resend, and code submission.
class OtpVerificationCubit extends Cubit<OtpVerificationState> {
  OtpVerificationCubit({
    required String phoneNumber,
    AuthRepository? repository,
  })  : _repository = repository ?? authRepository,
        super(OtpVerificationState(phoneNumber: phoneNumber)) {
    startTimer();
  }

  final AuthRepository _repository;
  Timer? _timer;

  void startTimer() {
    _timer?.cancel();
    emit(state.copyWith(countdown: 60));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.countdown > 0) {
        emit(state.copyWith(countdown: state.countdown - 1));
      } else {
        _timer?.cancel();
      }
    });
  }

  /// Verifies the 4-digit code. Returns the AuthUser on success, or null on failure.
  Future<AuthUser?> verifyOtp(String code) async {
    if (state.status.isLoading) return null;
    
    emit(state.copyWith(status: RequestStatus.loading, clearError: true));

    final result = await _repository.verifyOtp(
      phoneNumber: state.phoneNumber,
      code: code,
    );

    switch (result) {
      case AuthSuccess(:final user):
        _handleSuccess();
        return user;
      case AuthError(:final failure):
        _handleFailure(failure.message);
        return null;
    }
  }

  void _handleSuccess() {
    emit(state.copyWith(status: RequestStatus.success));
    _timer?.cancel();
  }

  void _handleFailure(String message) {
    emit(state.copyWith(
      status: RequestStatus.failure,
      errorMessage: message,
    ));
  }

  /// Resends the OTP and resets the countdown timer.
  Future<void> resendOtp() async {
    if (!state.canResend || state.status.isLoading) return;

    emit(state.copyWith(status: RequestStatus.loading, clearError: true));

    final result = await _repository.requestOtp(state.phoneNumber);

    switch (result) {
      case OtpSent():
        emit(state.copyWith(status: RequestStatus.idle));
        startTimer();
      case OtpError(:final failure):
        emit(state.copyWith(
          status: RequestStatus.failure,
          errorMessage: failure.message,
        ));
    }
  }

  /// Acknowledges error state so it can reset to idle.
  void acknowledgeError() {
    if (state.status.isFailure) {
      emit(state.copyWith(status: RequestStatus.idle, clearError: true));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

import '../../../../core/enums/request_status.dart';

/// Represents the UI state for the OTP Verification Screen.
class OtpVerificationState {
  const OtpVerificationState({
    this.status = RequestStatus.idle,
    this.errorMessage,
    this.countdown = 60,
    this.phoneNumber = '',
  });

  final RequestStatus status;
  final String? errorMessage;
  final int countdown;
  final String phoneNumber;

  bool get canResend => countdown == 0;

  OtpVerificationState copyWith({
    RequestStatus? status,
    String? errorMessage,
    int? countdown,
    String? phoneNumber,
    bool clearError = false,
  }) {
    return OtpVerificationState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      countdown: countdown ?? this.countdown,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}

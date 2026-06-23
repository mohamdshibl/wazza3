import '../../../../core/enums/request_status.dart';
import '../../data/models/auth_method.dart';
import '../../data/models/country.dart';

/// Immutable UI state for the sign-in screen.
///
/// Holds the chosen auth method, the dialing [country] (phone mode),
/// password visibility, and the async submission [status]
/// (idle / loading / success / failure).
class SignInState {
  const SignInState({
    this.method = AuthMethod.email,
    this.country = Countries.fallback,
    this.obscurePassword = true,
    this.status = RequestStatus.idle,
    this.errorMessage,
  });

  final AuthMethod method;
  final Country country;
  final bool obscurePassword;
  final RequestStatus status;
  final String? errorMessage;

  SignInState copyWith({
    AuthMethod? method,
    Country? country,
    bool? obscurePassword,
    RequestStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SignInState(
      method: method ?? this.method,
      country: country ?? this.country,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/request_status.dart';
import '../../data/models/auth_method.dart';
import '../../data/models/country.dart';
import '../../data/models/login_params.dart';
import '../../data/repos/auth_repository.dart';
import 'sign_in_state.dart';

/// Owns all sign-in business logic. The UI only reads [SignInState] and
/// calls intent methods — no logic lives in widgets.
class SignInController extends Notifier<SignInState> {
  @override
  SignInState build() => const SignInState();

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  void selectMethod(AuthMethod method) {
    if (method == state.method) return;
    state = state.copyWith(method: method, clearError: true);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void selectCountry(Country country) {
    if (country == state.country) return;
    state = state.copyWith(country: country, clearError: true);
  }

  /// Submits credentials. [identifier] is the email or phone depending on
  /// the active [AuthMethod]. Validation of the inputs happens in the form;
  /// callers should only invoke this once the form is valid.
  Future<void> signIn({
    required String identifier,
    required String password,
  }) async {
    state = state.copyWith(status: RequestStatus.loading, clearError: true);

    final result = await _repository.signIn(
      LoginParams(
        method: state.method,
        identifier: identifier.trim(),
        password: password,
      ),
    );

    state = switch (result) {
      AuthSuccess() => state.copyWith(status: RequestStatus.success),
      AuthError(:final failure) => state.copyWith(
          status: RequestStatus.failure,
          errorMessage: failure.message,
        ),
    };
  }

  /// Requests an OTP for the current [Country] + local [number].
  Future<void> requestOtp({required String number}) async {
    state = state.copyWith(status: RequestStatus.loading, clearError: true);

    final fullNumber =
        '${state.country.dialCode}${number.replaceAll(RegExp(r'\s'), '')}';
    final result = await _repository.requestOtp(fullNumber);

    state = switch (result) {
      OtpSent() => state.copyWith(status: RequestStatus.success),
      OtpError(:final failure) => state.copyWith(
          status: RequestStatus.failure,
          errorMessage: failure.message,
        ),
    };
  }

  /// Called after the UI has shown the failure (e.g. snackbar) so a retry
  /// starts clean.
  void acknowledgeError() {
    if (state.status.isFailure) {
      state = state.copyWith(status: RequestStatus.idle, clearError: true);
    }
  }
}

final signInControllerProvider =
    NotifierProvider<SignInController, SignInState>(SignInController.new);

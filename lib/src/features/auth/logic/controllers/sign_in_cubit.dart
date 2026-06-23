import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/request_status.dart';
import '../../data/models/auth_method.dart';
import '../../data/models/country.dart';
import '../../data/models/login_params.dart';
import '../../data/repos/auth_repository.dart';
import 'sign_in_state.dart';

/// Owns all sign-in business logic using Cubit.
class SignInCubit extends Cubit<SignInState> {
  SignInCubit({AuthRepository? repository})
      : _repository = repository ?? authRepository,
        super(const SignInState());

  final AuthRepository _repository;

  void selectMethod(AuthMethod method) {
    if (method == state.method) return;
    emit(state.copyWith(method: method, clearError: true));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void selectCountry(Country country) {
    if (country == state.country) return;
    emit(state.copyWith(country: country, clearError: true));
  }

  /// Submits credentials.
  Future<void> signIn({
    required String identifier,
    required String password,
  }) async {
    emit(state.copyWith(status: RequestStatus.loading, clearError: true));

    final result = await _repository.signIn(
      LoginParams(
        method: state.method,
        identifier: identifier.trim(),
        password: password,
      ),
    );

    emit(switch (result) {
      AuthSuccess() => state.copyWith(status: RequestStatus.success),
      AuthError(:final failure) => state.copyWith(
          status: RequestStatus.failure,
          errorMessage: failure.message,
        ),
    });
  }

  /// Requests an OTP for the current Country + local number.
  Future<void> requestOtp({required String number}) async {
    emit(state.copyWith(status: RequestStatus.loading, clearError: true));

    final fullNumber =
        '${state.country.dialCode}${number.replaceAll(RegExp(r'\s'), '')}';
    final result = await _repository.requestOtp(fullNumber);

    emit(switch (result) {
      OtpSent() => state.copyWith(status: RequestStatus.success),
      OtpError(:final failure) => state.copyWith(
          status: RequestStatus.failure,
          errorMessage: failure.message,
        ),
    });
  }

  /// Called after the UI has shown the failure so a retry starts clean.
  void acknowledgeError() {
    if (state.status.isFailure) {
      emit(state.copyWith(status: RequestStatus.idle, clearError: true));
    }
  }
}

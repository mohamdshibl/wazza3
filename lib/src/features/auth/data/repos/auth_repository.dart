

import '../../../../core/errors/failure.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/auth_user.dart';
import '../models/login_params.dart';

/// Result wrapper so the logic layer can branch on success/failure without
/// try/catch leaking into controllers.
sealed class AuthResult {
  const AuthResult();
}

class AuthSuccess extends AuthResult {
  const AuthSuccess(this.user);
  final AuthUser user;
}

class AuthError extends AuthResult {
  const AuthError(this.failure);
  final Failure failure;
}

/// Outcome of an OTP request (no user yet — verification happens next).
sealed class OtpResult {
  const OtpResult();
}

class OtpSent extends OtpResult {
  const OtpSent();
}

class OtpError extends OtpResult {
  const OtpError(this.failure);
  final Failure failure;
}

abstract interface class AuthRepository {
  Future<AuthResult> signIn(LoginParams params);
  Future<OtpResult> requestOtp(String phoneNumber);
  Future<AuthResult> verifyOtp({required String phoneNumber, required String code});
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote);

  final AuthRemoteDataSource _remote;

  @override
  Future<AuthResult> signIn(LoginParams params) async {
    try {
      final user = await _remote.signIn(params);
      return AuthSuccess(user);
    } on Failure catch (f) {
      return AuthError(f);
    } catch (_) {
      return const AuthError(UnknownFailure());
    }
  }

  @override
  Future<OtpResult> requestOtp(String phoneNumber) async {
    try {
      await _remote.requestOtp(phoneNumber);
      return const OtpSent();
    } on Failure catch (f) {
      return OtpError(f);
    } catch (_) {
      return const OtpError(UnknownFailure());
    }
  }

  @override
  Future<AuthResult> verifyOtp({required String phoneNumber, required String code}) async {
    try {
      final user = await _remote.verifyOtp(phoneNumber: phoneNumber, code: code);
      return AuthSuccess(user);
    } on Failure catch (f) {
      return AuthError(f);
    } catch (_) {
      return const AuthError(UnknownFailure());
    }
  }
}

/// DI: repository wired to its data source.
final AuthRepository authRepository = AuthRepositoryImpl(FakeAuthRemoteDataSource()); //



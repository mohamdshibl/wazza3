import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../models/auth_user.dart';
import '../models/login_params.dart';

/// Talks to the backend. Implementations translate transport errors into
/// [Failure]s (no UI concerns here).
abstract interface class AuthRemoteDataSource {
  Future<AuthUser> signIn(LoginParams params);

  /// Requests an OTP to be sent to [phoneNumber] (full E.164 form).
  Future<void> requestOtp(String phoneNumber);
}

/// In-memory fake used until the real API is wired. Demonstrates the
/// success and failure paths so the UI states are exercisable.
class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<AuthUser> signIn(LoginParams params) async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));

    // Demo rule: a password of "wrong" simulates rejected credentials.
    if (params.password == 'wrong') {
      throw const AuthFailure();
    }

    return AuthUser(
      id: 'usr_001',
      name: params.identifier.split('@').first,
      token: 'demo-token',
    );
  }

  @override
  Future<void> requestOtp(String phoneNumber) async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));

    // Demo rule: a number ending in "0000" simulates a delivery failure.
    if (phoneNumber.endsWith('0000')) {
      throw const ServerFailure('Could not send OTP. Try again.');
    }
  }
}

/// DI: exposes the data source. Override in `ProviderScope` to swap the
/// real implementation in production / tests.
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => FakeAuthRemoteDataSource(),
);

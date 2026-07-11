import 'package:flutter/foundation.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/remote/odoo_client.dart';
import '../../../../core/config/app_config.dart';
import '../models/auth_user.dart';
import '../models/login_params.dart';

/// Talks to the backend. Implementations translate transport errors into
/// [Failure]s (no UI concerns here).
abstract interface class AuthRemoteDataSource {
  Future<AuthUser> signIn(LoginParams params);

  /// Requests an OTP to be sent to [phoneNumber] (full E.164 form).
  Future<void> requestOtp(String phoneNumber);

  /// Verifies [code] for [phoneNumber]; returns the authenticated user.
  Future<AuthUser> verifyOtp({required String phoneNumber, required String code});
}

/// Odoo implementation of the remote data source using JSON-RPC.
class OdooAuthRemoteDataSource implements AuthRemoteDataSource {
  OdooAuthRemoteDataSource(this._client);

  final OdooClient _client;

  @override
  Future<AuthUser> signIn(LoginParams params) async {
    try {
      final result = await _client.call(
        service: 'common',
        method: 'authenticate',
        args: [
          AppConfig.db,
          params.identifier,
          params.password,
          const {}, // Empty options dictionary
        ],
      );

      // Odoo authenticate returns:
      // uid (integer) on success, or false (bool) on failure.
      if (result == false || result == null) {
        throw const AuthFailure('Invalid database, username, or password.');
      }

      final uid = result as int;

      // Stateless verify/read call to fetch the user's name
      String name = params.identifier;
      try {
        final userDataList = await _client.call(
          service: 'object',
          method: 'execute_kw',
          args: [
            AppConfig.db,
            uid,
            params.password, // Authenticating with user password
            'res.users',
            'read',
            [[uid]],
          ],
          kwargs: const {
            'fields': ['name'],
          },
        );

        if (userDataList is List && userDataList.isNotEmpty) {
          final userData = userDataList.first;
          if (userData is Map && userData.containsKey('name')) {
            name = userData['name'] as String;
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Odoo read name failed: $e');
        }
      }

      return AuthUser(
        id: uid.toString(),
        name: name,
        token: params.password, // Store password as the token for subsequent stateless RPC calls
      );
    } on AuthFailure {
      rethrow;
    } on OdooException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw const ServerFailure('Could not connect to Odoo server.');
    }
  }

  @override
  Future<void> requestOtp(String phoneNumber) async {
    // Odoo authenticate uses db/login/password. We mock OTP success for validation.
    await Future<void>.delayed(const Duration(milliseconds: 800));
  }

  @override
  Future<AuthUser> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return AuthUser(
      id: '2',
      name: 'Odoo OTP User',
      token: 'otp-verified-dummy-pass',
    );
  }
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

  @override
  Future<AuthUser> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));

    // Demo rule: code "0000" simulates wrong OTP.
    if (code == '0000') {
      throw const AuthFailure('Invalid OTP. Please try again.');
    }

    return AuthUser(
      id: 'usr_001',
      name: 'Driver',
      token: 'demo-token-otp',
    );
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:wazza3/src/core/enums/request_status.dart';
import 'package:wazza3/src/features/auth/data/models/auth_method.dart';
import 'package:wazza3/src/features/auth/data/models/login_params.dart';
import 'package:wazza3/src/features/auth/data/models/auth_user.dart';
import 'package:wazza3/src/features/auth/data/repos/auth_repository.dart';
import 'package:wazza3/src/features/auth/logic/controllers/sign_in_cubit.dart';
import 'package:wazza3/src/features/auth/logic/controllers/otp_verification_cubit.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<AuthResult> signIn(LoginParams params) async {
    return AuthSuccess(AuthUser(id: '1', name: 'Test User', token: 'token'));
  }

  @override
  Future<OtpResult> requestOtp(String phoneNumber) async {
    return const OtpSent();
  }

  @override
  Future<AuthResult> verifyOtp({required String phoneNumber, required String code}) async {
    return AuthSuccess(AuthUser(id: '1', name: 'Test User', token: 'token'));
  }
}

void main() {
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
  });

  group('SignInCubit Tests', () {
    test('initial state is correct', () {
      final cubit = SignInCubit(repository: repository);
      expect(cubit.state.method, AuthMethod.email);
      expect(cubit.state.status, RequestStatus.idle);
      cubit.close();
    });

    test('selectMethod updates state method', () {
      final cubit = SignInCubit(repository: repository);
      cubit.selectMethod(AuthMethod.phone);
      expect(cubit.state.method, AuthMethod.phone);
      cubit.close();
    });

    test('signIn triggers loading then success status', () async {
      final cubit = SignInCubit(repository: repository);
      final states = <RequestStatus>[];
      cubit.stream.listen((state) => states.add(state.status));

      await cubit.signIn(identifier: 'test@email.com', password: 'password');

      expect(states, contains(RequestStatus.loading));
      expect(cubit.state.status, RequestStatus.success);
      cubit.close();
    });
  });

  group('OtpVerificationCubit Tests', () {
    test('initial state starts countdown', () async {
      final cubit = OtpVerificationCubit(phoneNumber: '+1234567890', repository: repository);
      expect(cubit.state.phoneNumber, '+1234567890');
      expect(cubit.state.countdown, 60);
      cubit.close();
    });

    test('verifyOtp transitions to success', () async {
      final cubit = OtpVerificationCubit(phoneNumber: '+1234567890', repository: repository);
      final user = await cubit.verifyOtp('1234');
      expect(user, isNotNull);
      expect(cubit.state.status, RequestStatus.success);
      cubit.close();
    });
  });
}

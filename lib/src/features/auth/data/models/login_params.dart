import 'auth_method.dart';

/// Immutable request payload sent to the auth data source.
class LoginParams {
  const LoginParams({
    required this.method,
    required this.identifier,
    required this.password,
  });

  /// email or phone, depending on [method].
  final String identifier;
  final String password;
  final AuthMethod method;

  Map<String, dynamic> toJson() => {
        if (method == AuthMethod.email) 'email': identifier else 'phone': identifier,
        'password': password,
      };
}

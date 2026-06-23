/// Authenticated user returned on a successful sign-in.
class AuthUser {
  const AuthUser({
    required this.id,
    required this.name,
    required this.token,
  });

  final String id;
  final String name;
  final String token;

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'] as String,
        name: json['name'] as String,
        token: json['token'] as String,
      );
}

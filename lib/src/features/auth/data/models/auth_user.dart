/// Authenticated user returned on a successful sign-in.
class AuthUser {
  const AuthUser({
    required this.id,
    required this.name,
    required this.token,
    this.employeeCode,
    this.mustChangePassword = false,
  });

  final String id;
  final String name;
  final String token;
  final String? employeeCode;
  final bool mustChangePassword;

  int get uid => int.tryParse(id) ?? 0;

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'] as String,
        name: json['name'] as String,
        token: json['token'] as String,
        employeeCode: json['employee_code'] as String?,
        mustChangePassword: json['must_change_password'] == true,
      );

  AuthUser copyWith({
    String? id,
    String? name,
    String? token,
    String? employeeCode,
    bool? mustChangePassword,
  }) {
    return AuthUser(
      id: id ?? this.id,
      name: name ?? this.name,
      token: token ?? this.token,
      employeeCode: employeeCode ?? this.employeeCode,
      mustChangePassword: mustChangePassword ?? this.mustChangePassword,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'token': token,
        if (employeeCode != null) 'employee_code': employeeCode,
        'must_change_password': mustChangePassword,
      };
}


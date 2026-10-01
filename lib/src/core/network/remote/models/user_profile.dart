/// Model representing the sales rep profile returned by `get_profile`.
class UserProfile {
  const UserProfile({
    required this.name,
    this.employeeCode,
    this.mustChangePassword = false,
    this.vehicles = const [],
    this.areas = const [],
    this.raw = const {},
  });

  final String name;
  final String? employeeCode;
  final bool mustChangePassword;
  final List<VehicleInfo> vehicles;
  final List<AreaInfo> areas;
  final Map<String, dynamic> raw;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    List<VehicleInfo> parsedVehicles = [];
    if (json['vehicles'] is List) {
      parsedVehicles = (json['vehicles'] as List)
          .map((v) => v is Map<String, dynamic>
              ? VehicleInfo.fromJson(v)
              : VehicleInfo(name: v.toString()))
          .toList();
    }

    List<AreaInfo> parsedAreas = [];
    if (json['areas'] is List) {
      parsedAreas = (json['areas'] as List)
          .map((a) => a is Map<String, dynamic>
              ? AreaInfo.fromJson(a)
              : AreaInfo(name: a.toString()))
          .toList();
    }

    return UserProfile(
      name: json['name']?.toString() ?? '',
      employeeCode: json['employee_code']?.toString() ?? json['employeeCode']?.toString(),
      mustChangePassword: json['must_change_password'] == true ||
          json['mustChangePassword'] == true ||
          json['must_change_password'] == 1,
      vehicles: parsedVehicles,
      areas: parsedAreas,
      raw: json,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'employee_code': employeeCode,
        'must_change_password': mustChangePassword,
        'vehicles': vehicles.map((v) => v.toJson()).toList(),
        'areas': areas.map((a) => a.toJson()).toList(),
        ...raw,
      };
}

class VehicleInfo {
  const VehicleInfo({
    this.id,
    required this.name,
    this.licensePlate,
    this.model,
  });

  final int? id;
  final String name;
  final String? licensePlate;
  final String? model;

  factory VehicleInfo.fromJson(Map<String, dynamic> json) {
    return VehicleInfo(
      id: json['id'] as int?,
      name: json['name']?.toString() ?? '',
      licensePlate: json['license_plate']?.toString() ?? json['plate']?.toString(),
      model: json['model']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'name': name,
        if (licensePlate != null) 'license_plate': licensePlate,
        if (model != null) 'model': model,
      };
}

class AreaInfo {
  const AreaInfo({
    this.id,
    required this.name,
    this.code,
  });

  final int? id;
  final String name;
  final String? code;

  factory AreaInfo.fromJson(Map<String, dynamic> json) {
    return AreaInfo(
      id: json['id'] as int?,
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'name': name,
        if (code != null) 'code': code,
      };
}

/// Model representing the sales rep profile returned by `get_profile`.
class UserProfile {
  const UserProfile({
    required this.name,
    this.employeeCode,
    this.username,
    this.mustChangePassword = false,
    this.vehicles = const [],
    this.areas = const [],
    this.raw = const {},
  });

  final String name;
  final String? employeeCode;
  final String? username;
  final bool mustChangePassword;
  final List<VehicleInfo> vehicles;
  final List<AreaInfo> areas;
  final Map<String, dynamic> raw;

  factory UserProfile.fromJson(dynamic rawData) {
    if (rawData is! Map) {
      return const UserProfile(name: '');
    }

    final json = <String, dynamic>{};
    for (final entry in rawData.entries) {
      json[entry.key.toString()] = entry.value;
    }

    List<VehicleInfo> parsedVehicles = [];
    if (json['vehicles'] is List) {
      for (final v in json['vehicles'] as List) {
        if (v is Map) {
          parsedVehicles.add(VehicleInfo.fromJson(v));
        } else if (v != null) {
          parsedVehicles.add(VehicleInfo(name: v.toString()));
        }
      }
    }

    List<AreaInfo> parsedAreas = [];
    if (json['areas'] is List) {
      for (final a in json['areas'] as List) {
        if (a is Map) {
          parsedAreas.add(AreaInfo.fromJson(a));
        } else if (a != null) {
          parsedAreas.add(AreaInfo(name: a.toString()));
        }
      }
    }

    return UserProfile(
      name: json['name']?.toString() ?? '',
      employeeCode: json['employee_code']?.toString() ?? json['employeeCode']?.toString(),
      username: json['username']?.toString(),
      mustChangePassword: json['must_change_password'] == true ||
          json['mustChangePassword'] == true ||
          json['must_change_password'] == 1 ||
          json['must_change_password']?.toString().toLowerCase() == 'true',
      vehicles: parsedVehicles,
      areas: parsedAreas,
      raw: json,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        if (employeeCode != null) 'employee_code': employeeCode,
        if (username != null) 'username': username,
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

  factory VehicleInfo.fromJson(dynamic rawData) {
    if (rawData is! Map) {
      return VehicleInfo(name: rawData?.toString() ?? '');
    }

    final json = <String, dynamic>{};
    for (final entry in rawData.entries) {
      json[entry.key.toString()] = entry.value;
    }

    int? parsedId;
    if (json['id'] is num) {
      parsedId = (json['id'] as num).toInt();
    } else if (json['id'] is String) {
      parsedId = int.tryParse(json['id'] as String);
    }

    return VehicleInfo(
      id: parsedId,
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

  factory AreaInfo.fromJson(dynamic rawData) {
    if (rawData is! Map) {
      return AreaInfo(name: rawData?.toString() ?? '');
    }

    final json = <String, dynamic>{};
    for (final entry in rawData.entries) {
      json[entry.key.toString()] = entry.value;
    }

    int? parsedId;
    if (json['id'] is num) {
      parsedId = (json['id'] as num).toInt();
    } else if (json['id'] is String) {
      parsedId = int.tryParse(json['id'] as String);
    }

    return AreaInfo(
      id: parsedId,
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

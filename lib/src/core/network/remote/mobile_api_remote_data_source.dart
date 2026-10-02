import '../../config/app_config.dart';
import '../../errors/failure.dart';
import 'api_response.dart';
import 'models/models.dart';
import 'odoo_client.dart';

/// Contract for calling Odoo 18 `nx.mobile.api` endpoints.
abstract interface class MobileApiRemoteDataSource {
  /// Authenticates user and returns uid (or throws [AuthFailure]).
  Future<int> authenticate({
    required String login,
    required String password,
    String? db,
  });

  /// 1. get_profile: Name, employee code, must_change_password, vehicles, areas.
  Future<ApiResponse<UserProfile>> getProfile({
    required int uid,
    required String password,
    String? db,
  });

  /// 2. get_home: Current order + stage + actions, or history.
  Future<ApiResponse<HomeData>> getHome({
    required int uid,
    required String password,
    String? db,
  });

  /// 3. get_order: Order detail by [doId].
  Future<ApiResponse<DeliveryOrder>> getOrder({
    required int uid,
    required String password,
    required int doId,
    String? db,
  });

  /// 4. start_loading: Stage `go_to_warehouse` -> `loading` (idempotent).
  Future<ApiResponse<dynamic>> startLoading({
    required int uid,
    required String password,
    required int doId,
    String? db,
  });

  /// 5. get_notifications: Events proceed_to_warehouse / loading_validated.
  Future<ApiResponse<List<MobileNotification>>> getNotifications({
    required int uid,
    required String password,
    bool unreadOnly = true,
    String? db,
  });

  /// 6. get_loaded_goods: After warehouse keeper validated loading in Odoo.
  Future<ApiResponse<LoadedGoods>> getLoadedGoods({
    required int uid,
    required String password,
    required int doId,
    String? db,
  });

  /// 7. confirm_loaded_goods: Stage `confirm_loaded_goods` -> `ready_to_start_trip`.
  Future<ApiResponse<dynamic>> confirmLoadedGoods({
    required int uid,
    required String password,
    required int doId,
    String? db,
  });

  /// 8. start_trip: Stage `ready_to_start_trip` -> `on_trip`.
  Future<ApiResponse<dynamic>> startTrip({
    required int uid,
    required String password,
    required int doId,
    String? db,
  });

  /// 9. get_history: Previous orders of this rep ([limit], [offset]).
  Future<ApiResponse<List<DeliveryOrder>>> getHistory({
    required int uid,
    required String password,
    int limit = 20,
    int offset = 0,
    String? db,
  });

  /// 10. mark_notifications_read: Marks list of notification IDs as read.
  Future<ApiResponse<dynamic>> markNotificationsRead({
    required int uid,
    required String password,
    required List<int> notificationIds,
    String? db,
  });

  /// 11. change_password: Change user password.
  Future<ApiResponse<dynamic>> changePassword({
    required int uid,
    required String oldPassword,
    required String newPassword,
    String? db,
  });
}

/// Odoo implementation of [MobileApiRemoteDataSource] using [OdooClient].
class OdooMobileApiRemoteDataSource implements MobileApiRemoteDataSource {
  OdooMobileApiRemoteDataSource(this._client);

  final OdooClient _client;
  static const String _model = 'nx.mobile.api';

  @override
  Future<int> authenticate({
    required String login,
    required String password,
    String? db,
  }) async {
    try {
      final result = await _client.call(
        service: 'common',
        method: 'authenticate',
        args: [
          db ?? AppConfig.db,
          login,
          password,
          const {},
        ],
      );

      if (result == false || result == null) {
        throw const AuthFailure('Invalid credentials or database.');
      }

      return (result as num).toInt();
    } on Failure {
      rethrow;
    } on OdooException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw const ServerFailure('Failed to authenticate with Odoo server.');
    }
  }

  @override
  Future<ApiResponse<UserProfile>> getProfile({
    required int uid,
    required String password,
    String? db,
  }) async {
    final responseMap = await _executeKw(
      uid: uid,
      password: password,
      method: 'get_profile',
      args: const [],
      db: db,
    );

    return ApiResponse.fromJson(
      responseMap,
      (data) => UserProfile.fromJson(data),
    );
  }

  @override
  Future<ApiResponse<HomeData>> getHome({
    required int uid,
    required String password,
    String? db,
  }) async {
    final responseMap = await _executeKw(
      uid: uid,
      password: password,
      method: 'get_home',
      args: const [],
      db: db,
    );

    return ApiResponse.fromJson(
      responseMap,
      (data) => HomeData.fromJson(data is Map ? Map<String, dynamic>.from(data) : {}),
    );
  }

  @override
  Future<ApiResponse<DeliveryOrder>> getOrder({
    required int uid,
    required String password,
    required int doId,
    String? db,
  }) async {
    final responseMap = await _executeKw(
      uid: uid,
      password: password,
      method: 'get_order',
      args: [doId],
      db: db,
    );

    return ApiResponse.fromJson(
      responseMap,
      (data) => DeliveryOrder.fromJson(data is Map ? Map<String, dynamic>.from(data) : {}),
    );
  }

  @override
  Future<ApiResponse<dynamic>> startLoading({
    required int uid,
    required String password,
    required int doId,
    String? db,
  }) async {
    final responseMap = await _executeKw(
      uid: uid,
      password: password,
      method: 'start_loading',
      args: [doId],
      db: db,
    );

    return ApiResponse.fromJson(responseMap, (data) => data);
  }

  @override
  Future<ApiResponse<List<MobileNotification>>> getNotifications({
    required int uid,
    required String password,
    bool unreadOnly = true,
    String? db,
  }) async {
    final responseMap = await _executeKw(
      uid: uid,
      password: password,
      method: 'get_notifications',
      args: [unreadOnly],
      db: db,
    );

    return ApiResponse.fromJson(
      responseMap,
      (data) {
        if (data is List) {
          return data
              .whereType<Map>()
              .map((item) => MobileNotification.fromJson(Map<String, dynamic>.from(item)))
              .toList();
        }
        return <MobileNotification>[];
      },
    );
  }

  @override
  Future<ApiResponse<LoadedGoods>> getLoadedGoods({
    required int uid,
    required String password,
    required int doId,
    String? db,
  }) async {
    final responseMap = await _executeKw(
      uid: uid,
      password: password,
      method: 'get_loaded_goods',
      args: [doId],
      db: db,
    );

    return ApiResponse.fromJson(
      responseMap,
      (data) {
        if (data is Map) {
          return LoadedGoods.fromJson(Map<String, dynamic>.from(data));
        } else if (data is List) {
          return LoadedGoods.fromJson({'goods': data, 'do_id': doId});
        }
        return const LoadedGoods();
      },
    );
  }

  @override
  Future<ApiResponse<dynamic>> confirmLoadedGoods({
    required int uid,
    required String password,
    required int doId,
    String? db,
  }) async {
    final responseMap = await _executeKw(
      uid: uid,
      password: password,
      method: 'confirm_loaded_goods',
      args: [doId],
      db: db,
    );

    return ApiResponse.fromJson(responseMap, (data) => data);
  }

  @override
  Future<ApiResponse<dynamic>> startTrip({
    required int uid,
    required String password,
    required int doId,
    String? db,
  }) async {
    final responseMap = await _executeKw(
      uid: uid,
      password: password,
      method: 'start_trip',
      args: [doId],
      db: db,
    );

    return ApiResponse.fromJson(responseMap, (data) => data);
  }

  @override
  Future<ApiResponse<List<DeliveryOrder>>> getHistory({
    required int uid,
    required String password,
    int limit = 20,
    int offset = 0,
    String? db,
  }) async {
    final responseMap = await _executeKw(
      uid: uid,
      password: password,
      method: 'get_history',
      args: [limit, offset],
      db: db,
    );

    return ApiResponse.fromJson(
      responseMap,
      (data) {
        if (data is List) {
          return data
              .whereType<Map>()
              .map((item) => DeliveryOrder.fromJson(Map<String, dynamic>.from(item)))
              .toList();
        } else if (data is Map && data['orders'] is List) {
          return (data['orders'] as List)
              .whereType<Map>()
              .map((item) => DeliveryOrder.fromJson(Map<String, dynamic>.from(item)))
              .toList();
        }
        return <DeliveryOrder>[];
      },
    );
  }

  @override
  Future<ApiResponse<dynamic>> markNotificationsRead({
    required int uid,
    required String password,
    required List<int> notificationIds,
    String? db,
  }) async {
    final responseMap = await _executeKw(
      uid: uid,
      password: password,
      method: 'mark_notifications_read',
      args: [notificationIds],
      db: db,
    );

    return ApiResponse.fromJson(responseMap, (data) => data);
  }

  @override
  Future<ApiResponse<dynamic>> changePassword({
    required int uid,
    required String oldPassword,
    required String newPassword,
    String? db,
  }) async {
    final responseMap = await _executeKw(
      uid: uid,
      password: oldPassword,
      method: 'change_password',
      args: [oldPassword, newPassword],
      db: db,
    );

    return ApiResponse.fromJson(responseMap, (data) => data);
  }

  /// Helper to invoke `execute_kw` on `nx.mobile.api`.
  Future<Map<String, dynamic>> _executeKw({
    required int uid,
    required String password,
    required String method,
    required List<dynamic> args,
    String? db,
  }) async {
    try {
      final result = await _client.call(
        service: 'object',
        method: 'execute_kw',
        args: [
          db ?? AppConfig.db,
          uid,
          password,
          _model,
          method,
          args,
        ],
      );

      if (result is Map<String, dynamic>) {
        return result;
      } else if (result is Map) {
        return Map<String, dynamic>.from(result);
      } else {
        return {
          'success': true,
          'code': 200,
          'message': 'Success',
          'data': result,
        };
      }
    } on Failure {
      rethrow;
    } on OdooException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('RPC call to $method failed: $e');
    }
  }
}

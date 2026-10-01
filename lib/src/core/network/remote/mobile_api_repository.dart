import '../../errors/failure.dart';
import 'mobile_api_remote_data_source.dart';
import 'models/models.dart';
import 'odoo_client.dart';

/// Repository contract for nx.mobile.api operations.
abstract interface class MobileApiRepository {
  Future<UserProfile> getProfile({required int uid, required String password});

  Future<HomeData> getHome({required int uid, required String password});

  Future<DeliveryOrder> getOrder({
    required int uid,
    required String password,
    required int doId,
  });

  Future<void> startLoading({
    required int uid,
    required String password,
    required int doId,
  });

  Future<List<MobileNotification>> getNotifications({
    required int uid,
    required String password,
    bool unreadOnly = true,
  });

  Future<LoadedGoods> getLoadedGoods({
    required int uid,
    required String password,
    required int doId,
  });

  Future<void> confirmLoadedGoods({
    required int uid,
    required String password,
    required int doId,
  });

  Future<void> startTrip({
    required int uid,
    required String password,
    required int doId,
  });

  Future<List<DeliveryOrder>> getHistory({
    required int uid,
    required String password,
    int limit = 20,
    int offset = 0,
  });

  Future<void> markNotificationsRead({
    required int uid,
    required String password,
    required List<int> notificationIds,
  });

  Future<void> changePassword({
    required int uid,
    required String oldPassword,
    required String newPassword,
  });
}

class MobileApiRepositoryImpl implements MobileApiRepository {
  MobileApiRepositoryImpl(this._remote);

  final MobileApiRemoteDataSource _remote;

  @override
  Future<UserProfile> getProfile({
    required int uid,
    required String password,
  }) async {
    try {
      final response = await _remote.getProfile(uid: uid, password: password);
      if (!response.isSuccess || response.data == null) {
        throw ServerFailure(
          response.message.isNotEmpty ? response.message : 'Failed to fetch profile',
        );
      }
      return response.data!;
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<HomeData> getHome({
    required int uid,
    required String password,
  }) async {
    try {
      final response = await _remote.getHome(uid: uid, password: password);
      if (!response.isSuccess || response.data == null) {
        throw ServerFailure(
          response.message.isNotEmpty ? response.message : 'Failed to fetch home data',
        );
      }
      return response.data!;
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<DeliveryOrder> getOrder({
    required int uid,
    required String password,
    required int doId,
  }) async {
    try {
      final response = await _remote.getOrder(
        uid: uid,
        password: password,
        doId: doId,
      );
      if (!response.isSuccess || response.data == null) {
        throw ServerFailure(
          response.message.isNotEmpty ? response.message : 'Failed to fetch order details',
        );
      }
      return response.data!;
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> startLoading({
    required int uid,
    required String password,
    required int doId,
  }) async {
    try {
      final response = await _remote.startLoading(
        uid: uid,
        password: password,
        doId: doId,
      );
      if (!response.isSuccess) {
        throw ServerFailure(
          response.message.isNotEmpty ? response.message : 'Failed to start loading',
        );
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<MobileNotification>> getNotifications({
    required int uid,
    required String password,
    bool unreadOnly = true,
  }) async {
    try {
      final response = await _remote.getNotifications(
        uid: uid,
        password: password,
        unreadOnly: unreadOnly,
      );
      if (!response.isSuccess || response.data == null) {
        throw ServerFailure(
          response.message.isNotEmpty ? response.message : 'Failed to fetch notifications',
        );
      }
      return response.data!;
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<LoadedGoods> getLoadedGoods({
    required int uid,
    required String password,
    required int doId,
  }) async {
    try {
      final response = await _remote.getLoadedGoods(
        uid: uid,
        password: password,
        doId: doId,
      );
      if (!response.isSuccess || response.data == null) {
        throw ServerFailure(
          response.message.isNotEmpty ? response.message : 'Failed to fetch loaded goods',
        );
      }
      return response.data!;
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> confirmLoadedGoods({
    required int uid,
    required String password,
    required int doId,
  }) async {
    try {
      final response = await _remote.confirmLoadedGoods(
        uid: uid,
        password: password,
        doId: doId,
      );
      if (!response.isSuccess) {
        throw ServerFailure(
          response.message.isNotEmpty ? response.message : 'Failed to confirm loaded goods',
        );
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> startTrip({
    required int uid,
    required String password,
    required int doId,
  }) async {
    try {
      final response = await _remote.startTrip(
        uid: uid,
        password: password,
        doId: doId,
      );
      if (!response.isSuccess) {
        throw ServerFailure(
          response.message.isNotEmpty ? response.message : 'Failed to start trip',
        );
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<DeliveryOrder>> getHistory({
    required int uid,
    required String password,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _remote.getHistory(
        uid: uid,
        password: password,
        limit: limit,
        offset: offset,
      );
      if (!response.isSuccess || response.data == null) {
        throw ServerFailure(
          response.message.isNotEmpty ? response.message : 'Failed to fetch order history',
        );
      }
      return response.data!;
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> markNotificationsRead({
    required int uid,
    required String password,
    required List<int> notificationIds,
  }) async {
    try {
      final response = await _remote.markNotificationsRead(
        uid: uid,
        password: password,
        notificationIds: notificationIds,
      );
      if (!response.isSuccess) {
        throw ServerFailure(
          response.message.isNotEmpty ? response.message : 'Failed to mark notifications as read',
        );
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> changePassword({
    required int uid,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _remote.changePassword(
        uid: uid,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      if (!response.isSuccess) {
        throw ServerFailure(
          response.message.isNotEmpty ? response.message : 'Failed to change password',
        );
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}

/// Global instance of [MobileApiRepository] wired with OdooClient
final MobileApiRepository mobileApiRepository = MobileApiRepositoryImpl(
  OdooMobileApiRemoteDataSource(OdooClientImpl()),
);

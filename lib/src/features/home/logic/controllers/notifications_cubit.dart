import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/request_status.dart';
import '../../../../core/network/remote/mobile_api_repository.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({MobileApiRepository? repository})
      : _repository = repository ?? mobileApiRepository,
        super(const NotificationsState());

  final MobileApiRepository _repository;

  /// Fetches unread or all notifications via get_notifications.
  Future<void> fetchNotifications({
    required int uid,
    required String password,
    bool unreadOnly = true,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      emit(state.copyWith(isRefreshing: true, clearError: true));
    } else {
      emit(state.copyWith(status: RequestStatus.loading, clearError: true));
    }

    try {
      final items = await _repository.getNotifications(
        uid: uid,
        password: password,
        unreadOnly: unreadOnly,
      );

      emit(state.copyWith(
        status: RequestStatus.success,
        notifications: items,
        isRefreshing: false,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RequestStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', '').replaceAll('ServerFailure: ', ''),
        isRefreshing: false,
      ));
    }
  }

  /// Marks specific notification IDs as read via mark_notifications_read.
  Future<void> markAsRead({
    required int uid,
    required String password,
    required List<int> notificationIds,
  }) async {
    if (notificationIds.isEmpty) return;

    emit(state.copyWith(isMarkingRead: true));

    try {
      await _repository.markNotificationsRead(
        uid: uid,
        password: password,
        notificationIds: notificationIds,
      );

      final updated = state.notifications.map((n) {
        if (notificationIds.contains(n.id)) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();

      emit(state.copyWith(
        notifications: updated,
        isMarkingRead: false,
      ));
    } catch (_) {
      emit(state.copyWith(isMarkingRead: false));
    }
  }
}

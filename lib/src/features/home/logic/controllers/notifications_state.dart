import '../../../../core/enums/request_status.dart';
import '../../../../core/network/remote/models/mobile_notification.dart';

class NotificationsState {
  const NotificationsState({
    this.status = RequestStatus.idle,
    this.notifications = const [],
    this.errorMessage,
    this.isRefreshing = false,
    this.isMarkingRead = false,
  });

  final RequestStatus status;
  final List<MobileNotification> notifications;
  final String? errorMessage;
  final bool isRefreshing;
  final bool isMarkingRead;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  NotificationsState copyWith({
    RequestStatus? status,
    List<MobileNotification>? notifications,
    String? errorMessage,
    bool? isRefreshing,
    bool? isMarkingRead,
    bool clearError = false,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isMarkingRead: isMarkingRead ?? this.isMarkingRead,
    );
  }
}

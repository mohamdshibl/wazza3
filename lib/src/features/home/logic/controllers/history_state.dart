import '../../../../core/enums/request_status.dart';
import '../../../../core/network/remote/models/delivery_order.dart';

/// Immutable UI state for the Previous Orders / History screen.
class HistoryState {
  const HistoryState({
    this.status = RequestStatus.idle,
    this.orders = const [],
    this.errorMessage,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.isRefreshing = false,
  });

  final RequestStatus status;
  final List<DeliveryOrder> orders;
  final String? errorMessage;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isRefreshing;

  HistoryState copyWith({
    RequestStatus? status,
    List<DeliveryOrder>? orders,
    String? errorMessage,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isRefreshing,
    bool clearError = false,
  }) {
    return HistoryState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

import '../../../../core/enums/request_status.dart';
import '../../../../core/network/remote/models/delivery_order.dart';

class OrderDetailsState {
  const OrderDetailsState({
    this.status = RequestStatus.idle,
    this.order,
    this.errorMessage,
    this.isRefreshing = false,
    this.isActionLoading = false,
  });

  final RequestStatus status;
  final DeliveryOrder? order;
  final String? errorMessage;
  final bool isRefreshing;
  final bool isActionLoading;

  OrderDetailsState copyWith({
    RequestStatus? status,
    DeliveryOrder? order,
    String? errorMessage,
    bool? isRefreshing,
    bool? isActionLoading,
    bool clearError = false,
  }) {
    return OrderDetailsState(
      status: status ?? this.status,
      order: order ?? this.order,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isActionLoading: isActionLoading ?? this.isActionLoading,
    );
  }
}

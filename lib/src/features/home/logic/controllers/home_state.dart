import '../../../../core/enums/request_status.dart';
import '../../../../core/network/remote/models/home_data.dart';

/// Immutable UI state for the Home screen.
class HomeState {
  const HomeState({
    this.status = RequestStatus.idle,
    this.homeData,
    this.errorMessage,
    this.isRefreshing = false,
  });

  final RequestStatus status;
  final HomeData? homeData;
  final String? errorMessage;
  final bool isRefreshing;

  HomeState copyWith({
    RequestStatus? status,
    HomeData? homeData,
    String? errorMessage,
    bool? isRefreshing,
    bool clearError = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      homeData: homeData ?? this.homeData,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

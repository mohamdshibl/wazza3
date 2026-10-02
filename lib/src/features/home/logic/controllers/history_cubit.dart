import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/request_status.dart';
import '../../../../core/network/remote/mobile_api_repository.dart';
import '../../../../core/network/remote/models/delivery_order.dart';
import 'history_state.dart';

/// Cubit for fetching previous orders history with pagination support.
class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit({
    MobileApiRepository? repository,
    List<DeliveryOrder>? initialOrders,
  })  : _repository = repository ?? mobileApiRepository,
        super(HistoryState(
          status: initialOrders != null && initialOrders.isNotEmpty
              ? RequestStatus.success
              : RequestStatus.idle,
          orders: initialOrders ?? const [],
        ));

  final MobileApiRepository _repository;
  static const int _pageSize = 20;

  /// Loads the initial page or refreshes the history list.
  Future<void> fetchHistory({
    required int uid,
    required String password,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      emit(state.copyWith(isRefreshing: true, clearError: true));
    } else if (state.orders.isEmpty) {
      emit(state.copyWith(status: RequestStatus.loading, clearError: true));
    }

    try {
      final orders = await _repository.getHistory(
        uid: uid,
        password: password,
        limit: _pageSize,
        offset: 0,
      );

      final resultOrders = orders.isNotEmpty ? orders : state.orders;

      emit(state.copyWith(
        status: RequestStatus.success,
        orders: resultOrders,
        hasMore: orders.length >= _pageSize,
        isRefreshing: false,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: state.orders.isNotEmpty ? RequestStatus.success : RequestStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', '').replaceAll('ServerFailure: ', ''),
        isRefreshing: false,
      ));
    }
  }

  /// Loads the next page of history orders.
  Future<void> loadMore({
    required int uid,
    required String password,
  }) async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final nextOrders = await _repository.getHistory(
        uid: uid,
        password: password,
        limit: _pageSize,
        offset: state.orders.length,
      );

      final combined = List<DeliveryOrder>.from(state.orders)..addAll(nextOrders);

      emit(state.copyWith(
        orders: combined,
        hasMore: nextOrders.length >= _pageSize,
        isLoadingMore: false,
      ));
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }
}

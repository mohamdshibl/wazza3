import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/request_status.dart';
import '../../../../core/network/remote/mobile_api_repository.dart';
import '../../../../core/network/remote/models/delivery_order.dart';
import 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  OrderDetailsCubit({
    MobileApiRepository? repository,
    DeliveryOrder? initialOrder,
  })  : _repository = repository ?? mobileApiRepository,
        super(OrderDetailsState(
          status: initialOrder != null ? RequestStatus.success : RequestStatus.idle,
          order: initialOrder,
        ));

  final MobileApiRepository _repository;

  /// Fetches the complete order details via get_order RPC.
  Future<void> fetchOrder({
    required int uid,
    required String password,
    required int doId,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      emit(state.copyWith(isRefreshing: true, clearError: true));
    } else if (state.order == null) {
      emit(state.copyWith(status: RequestStatus.loading, clearError: true));
    }

    try {
      final order = await _repository.getOrder(
        uid: uid,
        password: password,
        doId: doId,
      );

      emit(state.copyWith(
        status: RequestStatus.success,
        order: order,
        isRefreshing: false,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: state.order != null ? RequestStatus.success : RequestStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', '').replaceAll('ServerFailure: ', ''),
        isRefreshing: false,
      ));
    }
  }

  /// Triggers start_loading RPC.
  Future<bool> startLoading({
    required int uid,
    required String password,
    required int doId,
  }) async {
    emit(state.copyWith(isActionLoading: true));
    try {
      await _repository.startLoading(
        uid: uid,
        password: password,
        doId: doId,
      );
      emit(state.copyWith(isActionLoading: false));
      await fetchOrder(uid: uid, password: password, doId: doId, isRefresh: true);
      return true;
    } catch (e) {
      emit(state.copyWith(
        isActionLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', '').replaceAll('ServerFailure: ', ''),
      ));
      return false;
    }
  }

  /// Triggers confirm_loaded_goods RPC.
  Future<bool> confirmLoadedGoods({
    required int uid,
    required String password,
    required int doId,
  }) async {
    emit(state.copyWith(isActionLoading: true));
    try {
      await _repository.confirmLoadedGoods(
        uid: uid,
        password: password,
        doId: doId,
      );
      emit(state.copyWith(isActionLoading: false));
      await fetchOrder(uid: uid, password: password, doId: doId, isRefresh: true);
      return true;
    } catch (e) {
      emit(state.copyWith(
        isActionLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', '').replaceAll('ServerFailure: ', ''),
      ));
      return false;
    }
  }

  /// Triggers start_trip RPC.
  Future<bool> startTrip({
    required int uid,
    required String password,
    required int doId,
  }) async {
    emit(state.copyWith(isActionLoading: true));
    try {
      await _repository.startTrip(
        uid: uid,
        password: password,
        doId: doId,
      );
      emit(state.copyWith(isActionLoading: false));
      await fetchOrder(uid: uid, password: password, doId: doId, isRefresh: true);
      return true;
    } catch (e) {
      emit(state.copyWith(
        isActionLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', '').replaceAll('ServerFailure: ', ''),
      ));
      return false;
    }
  }
}

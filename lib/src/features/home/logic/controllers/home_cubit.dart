import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/request_status.dart';
import '../../../../core/network/remote/mobile_api_repository.dart';
import 'home_state.dart';

/// Cubit managing home screen data (`get_home`).
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({MobileApiRepository? repository})
      : _repository = repository ?? mobileApiRepository,
        super(const HomeState());

  final MobileApiRepository _repository;

  /// Fetches the home screen payload for the current user.
  Future<void> fetchHome({
    required int uid,
    required String password,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      emit(state.copyWith(isRefreshing: true, clearError: true));
    } else {
      emit(state.copyWith(status: RequestStatus.loading, clearError: true));
    }

    try {
      final homeData = await _repository.getHome(
        uid: uid,
        password: password,
      );

      emit(state.copyWith(
        status: RequestStatus.success,
        homeData: homeData,
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
}

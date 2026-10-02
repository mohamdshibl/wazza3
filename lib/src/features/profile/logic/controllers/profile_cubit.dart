import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/request_status.dart';
import '../../../../core/network/remote/mobile_api_repository.dart';
import 'profile_state.dart';

/// Cubit managing profile data retrieval and state.
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({MobileApiRepository? repository})
      : _repository = repository ?? mobileApiRepository,
        super(const ProfileState());

  final MobileApiRepository _repository;

  /// Fetches the profile for the current user.
  Future<void> fetchProfile({
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
      final profile = await _repository.getProfile(
        uid: uid,
        password: password,
      );

      emit(state.copyWith(
        status: RequestStatus.success,
        profile: profile,
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

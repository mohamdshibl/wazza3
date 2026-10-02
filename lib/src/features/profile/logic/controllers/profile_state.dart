import '../../../../core/enums/request_status.dart';
import '../../../../core/network/remote/models/user_profile.dart';

/// Immutable UI state for the Profile screen.
class ProfileState {
  const ProfileState({
    this.status = RequestStatus.idle,
    this.profile,
    this.errorMessage,
    this.isRefreshing = false,
  });

  final RequestStatus status;
  final UserProfile? profile;
  final String? errorMessage;
  final bool isRefreshing;

  ProfileState copyWith({
    RequestStatus? status,
    UserProfile? profile,
    String? errorMessage,
    bool? isRefreshing,
    bool clearError = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

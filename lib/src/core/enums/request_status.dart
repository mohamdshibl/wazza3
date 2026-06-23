/// Generic lifecycle status for any async operation.
///
/// Covers the four UI states the screen must handle:
/// idle (initial/empty), loading, success, failure.
enum RequestStatus { idle, loading, success, failure }

extension RequestStatusX on RequestStatus {
  bool get isIdle => this == RequestStatus.idle;
  bool get isLoading => this == RequestStatus.loading;
  bool get isSuccess => this == RequestStatus.success;
  bool get isFailure => this == RequestStatus.failure;
}

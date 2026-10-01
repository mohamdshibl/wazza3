/// Generic envelope for responses returned by `nx.mobile.api` in Odoo 18.
class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  final bool success;
  final int code;
  final String message;
  final T? data;

  bool get isSuccess => success && code >= 200 && code < 300;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, [
    T Function(dynamic data)? fromData,
  ]) {
    final rawSuccess = json['success'];
    final success = rawSuccess is bool ? rawSuccess : (rawSuccess == 1 || rawSuccess == 'true');
    final code = (json['code'] as num?)?.toInt() ?? (success ? 200 : 400);
    final message = json['message']?.toString() ?? '';
    final rawData = json['data'];

    T? parsedData;
    if (rawData != null && fromData != null) {
      try {
        parsedData = fromData(rawData);
      } catch (e) {
        parsedData = null;
      }
    } else if (rawData is T) {
      parsedData = rawData;
    }

    return ApiResponse<T>(
      success: success,
      code: code,
      message: message,
      data: parsedData,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'code': code,
        'message': message,
        'data': data,
      };
}

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

  bool get isSuccess => success || (code >= 200 && code < 300);

  factory ApiResponse.fromJson(
    dynamic json, [
    T Function(dynamic data)? fromData,
  ]) {
    if (json is! Map) {
      return ApiResponse<T>(
        success: false,
        code: 500,
        message: 'Invalid response format',
        data: null,
      );
    }

    final rawSuccess = json['success'];
    final success = rawSuccess is bool
        ? rawSuccess
        : (rawSuccess == 1 || rawSuccess == 'true' || rawSuccess == 'True');

    final rawCode = json['code'];
    int code = 200;
    if (rawCode is num) {
      code = rawCode.toInt();
    } else if (rawCode is String) {
      if (rawCode.toLowerCase() == 'ok' || rawCode.toLowerCase() == 'success') {
        code = 200;
      } else {
        code = int.tryParse(rawCode) ?? (success ? 200 : 400);
      }
    } else {
      code = success ? 200 : 400;
    }

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

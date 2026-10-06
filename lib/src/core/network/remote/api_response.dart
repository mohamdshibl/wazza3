/// Generic envelope for responses returned by `nx.mobile.api` in Odoo 18.
class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    required this.code,
    this.errorCode = 'ok',
    required this.message,
    this.data,
  });

  final bool success;
  final int code;
  final String errorCode;
  final String message;
  final T? data;

  bool get isSuccess => success || (errorCode == 'ok' || errorCode == 'success' || (code >= 200 && code < 300));
  bool get isNotSalesRep => errorCode == 'not_sales_rep';
  bool get isNotFound => errorCode == 'not_found';
  bool get isInvalidState => errorCode == 'invalid_state';
  bool get isValidation => errorCode == 'validation';
  bool get isAccessDenied => errorCode == 'access_denied';

  factory ApiResponse.fromJson(
    dynamic json, [
    T Function(dynamic data)? fromData,
  ]) {
    if (json is! Map) {
      return ApiResponse<T>(
        success: false,
        code: 500,
        errorCode: 'error',
        message: 'Invalid response format',
        data: null,
      );
    }

    final rawSuccess = json['success'];
    final success = rawSuccess is bool
        ? rawSuccess
        : (rawSuccess == 1 || rawSuccess == 'true' || rawSuccess == 'True');

    final rawCode = json['code'];
    String errorCode = 'ok';
    int code = 200;

    if (rawCode is num) {
      code = rawCode.toInt();
      errorCode = success ? 'ok' : code.toString();
    } else if (rawCode is String) {
      errorCode = rawCode.toLowerCase();
      if (errorCode == 'ok' || errorCode == 'success') {
        code = 200;
      } else {
        code = int.tryParse(rawCode) ?? (success ? 200 : 400);
      }
    } else {
      code = success ? 200 : 400;
      errorCode = success ? 'ok' : 'error';
    }

    final message = json['message']?.toString() ?? '';
    final rawData = json['data'];

    T? parsedData;
    if (rawData != null && rawData != false && fromData != null) {
      try {
        parsedData = fromData(rawData);
      } catch (e) {
        parsedData = null;
      }
    } else if (rawData is T && rawData != false) {
      parsedData = rawData;
    }

    return ApiResponse<T>(
      success: success,
      code: code,
      errorCode: errorCode,
      message: message,
      data: parsedData,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'code': code,
        'error_code': errorCode,
        'message': message,
        'data': data,
      };
}

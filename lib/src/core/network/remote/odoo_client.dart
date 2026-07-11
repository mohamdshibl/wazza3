import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../config/app_config.dart';

abstract interface class OdooClient {
  Future<dynamic> call({
    required String service,
    required String method,
    required List<dynamic> args,
    Map<String, dynamic>? kwargs,
  });
}

class OdooClientImpl implements OdooClient {
  OdooClientImpl({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = AppConfig.baseUrl;
    _dio.options.connectTimeout = AppConfig.requestTimeout;
    _dio.options.receiveTimeout = AppConfig.requestTimeout;
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  final Dio _dio;
  int _requestId = 1;

  @override
  Future<dynamic> call({
    required String service,
    required String method,
    required List<dynamic> args,
    Map<String, dynamic>? kwargs,
  }) async {
    final id = _requestId++;
    final params = <String, dynamic>{
      'service': service,
      'method': method,
      'args': args,
    };
    if (kwargs != null) {
      params['kwargs'] = kwargs;
    }

    final payload = {
      'jsonrpc': '2.0',
      'method': 'call',
      'params': params,
      'id': id,
    };

    if (kDebugMode) {
      print('Odoo RPC Request [$id]: $service/$method with args: $args');
    }

    try {
      final response = await _dio.post(
        '/jsonrpc',
        data: payload,
      );

      final responseData = response.data;
      if (responseData is! Map<String, dynamic>) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Invalid response format from server (expected JSON Map).',
        );
      }

      if (responseData.containsKey('error')) {
        final error = responseData['error'];
        final message = error is Map ? error['message'] ?? 'Odoo RPC Error' : 'Odoo RPC Error';
        final data = error is Map ? error['data'] : null;
        final debugMessage = data is Map ? data['message'] ?? '' : '';
        
        throw OdooException(
          message: '$message: $debugMessage'.trim(),
          errorData: error,
        );
      }

      final result = responseData['result'];
      if (kDebugMode) {
        print('Odoo RPC Response [$id]: Success, result: $result');
      }
      return result;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Odoo RPC Error [$id] (DioException): ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Odoo RPC Error [$id]: $e');
      }
      rethrow;
    }
  }
}

class OdooException implements Exception {
  final String message;
  final dynamic errorData;

  const OdooException({required this.message, this.errorData});

  @override
  String toString() => 'OdooException: $message';
}

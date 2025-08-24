import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../error/app_exception.dart';
import '../../services/storage_local.dart';
import '../../repositories/token_repository.dart';

/// Logs basic request/response information.
class LoggingInterceptor extends Interceptor {
  final bool enable;
  LoggingInterceptor({this.enable = false});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enable) {
      options.extra['startTime'] = DateTime.now();
      final headers = Map.of(options.headers);
      if (headers.containsKey('Authorization')) {
        headers['Authorization'] = '***';
      }
      debugPrint('--> ${options.method} ${options.uri}');
      debugPrint('Headers: $headers');
      if (options.data != null) {
        debugPrint('Body: ${options.data}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (enable) {
      final start = response.requestOptions.extra['startTime'] as DateTime?;
      final duration = start != null
          ? DateTime.now().difference(start).inMilliseconds
          : null;
      debugPrint('<-- ${response.statusCode} ${response.requestOptions.uri} (${duration ?? '-'} ms)');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enable) {
      debugPrint('error: ${err.message}');
    }
    handler.next(err);
  }
}

/// Injects Authorization header from local storage.
class AuthInterceptor extends Interceptor {
  final StorageLocal storage;
  AuthInterceptor(this.storage);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await storage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

/// Retry once when encountering 401 responses.
class RetryOnAuthFailInterceptor extends Interceptor {
  final StorageLocal storage;
  final Dio dio;
  RetryOnAuthFailInterceptor(this.storage, this.dio);

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        err.requestOptions.extra['retried'] != true) {
      err.requestOptions.extra['retried'] = true;
      final newToken = await TokenRepository.refresh();
      if (newToken != null) {
        await storage.setToken(newToken);
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $newToken';
        try {
          final clone = await dio.fetch(opts);
          return handler.resolve(clone);
        } catch (_) {}
      }
      await storage.clearToken();
      return handler.next(err.copyWith(
          error: const AuthException('未授权', code: 401),
          response: err.response));
    }
    handler.next(err);
  }
}

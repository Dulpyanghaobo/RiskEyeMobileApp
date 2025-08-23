import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../error/app_exception.dart';

/// Injects auth token stored in [SharedPreferences].
class TokenInterceptor extends Interceptor {
  final SharedPreferences prefs;
  TokenInterceptor(this.prefs);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = prefs.getString('auth_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

/// Normalizes [DioException] into [AppException].
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    err.error = AppException.fromDio(err);
    handler.next(err);
  }
}

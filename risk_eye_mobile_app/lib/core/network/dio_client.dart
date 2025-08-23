import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import 'interceptors.dart';

/// Provides a configured [Dio] client.
class DioClient {
  final Dio _dio;

  DioClient._(this._dio);

  factory DioClient(SharedPreferences prefs) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    dio.interceptors.addAll([
      TokenInterceptor(prefs),
      ErrorInterceptor(),
      // LogInterceptor(), // enable to log network
    ]);
    // TODO: add retry interceptor if needed
    return DioClient._(dio);
  }

  Dio get client => _dio;
}

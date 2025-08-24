import 'dart:io';

import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../error/app_exception.dart';
import 'api_result.dart';
import 'interceptors.dart';
import '../../services/storage_local.dart';

typedef Parser<T> = T Function(dynamic data);

/// A wrapper around [Dio] providing typed requests.
class DioClient {
  final Dio _dio;

  DioClient._(this._dio);

  factory DioClient({
    Dio? dio,
    List<Interceptor>? interceptors,
    AppConfig? config,
    StorageLocal? storage,
  }) {
    final conf = config ?? AppConfig.current;
    final options = BaseOptions(
      baseUrl: conf.baseUrl,
      connectTimeout: conf.connectTimeout,
      receiveTimeout: conf.receiveTimeout,
      headers: {'Content-Type': 'application/json'},
    );
    final d = dio ?? Dio(options);
    final list = <Interceptor>[
      if (interceptors != null) ...interceptors,
      LoggingInterceptor(enable: conf.enableLog),
    ];
    if (storage != null) {
      list.add(AuthInterceptor(storage));
      list.add(RetryOnAuthFailInterceptor(storage, d));
    }
    d.interceptors.addAll(list);
    return DioClient._(d);
  }

  Dio get raw => _dio;

  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    Parser<T>? parser,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    return _request(() => _dio.get(path,
        queryParameters: query, cancelToken: cancelToken, options: options), parser);
  }

  Future<ApiResult<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Parser<T>? parser,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    return _request(() => _dio.post(path,
        data: data,
        queryParameters: query,
        cancelToken: cancelToken,
        options: options), parser);
  }

  Future<ApiResult<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Parser<T>? parser,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    return _request(() => _dio.put(path,
        data: data,
        queryParameters: query,
        cancelToken: cancelToken,
        options: options), parser);
  }

  Future<ApiResult<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Parser<T>? parser,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    return _request(() => _dio.patch(path,
        data: data,
        queryParameters: query,
        cancelToken: cancelToken,
        options: options), parser);
  }

  Future<ApiResult<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Parser<T>? parser,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    return _request(() => _dio.delete(path,
        data: data,
        queryParameters: query,
        cancelToken: cancelToken,
        options: options), parser);
  }

  Future<ApiResult<T>> upload<T>(
    String path, {
    required dynamic file,
    String fileKey = 'file',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    Parser<T>? parser,
    CancelToken? cancelToken,
  }) async {
    final formMap = <String, dynamic>{...?(data ?? {})};
    formMap[fileKey] = await _toMultipartFile(file);
    final formData = FormData.fromMap(formMap);
    return _request(
      () => _dio.post(path,
          data: formData,
          onSendProgress: onSendProgress,
          cancelToken: cancelToken),
      parser,
    );
  }

  Future<ApiResult<T>> _request<T>(
    Future<Response<dynamic>> Function() call,
    Parser<T>? parser,
  ) async {
    try {
      final res = await call();
      final data = parser != null ? parser(res.data) : res.data as T;
      return ApiResult.success(data);
    } on DioException catch (e) {
      return ApiResult.failure(AppException.fromDio(e));
    } catch (e) {
      return ApiResult.failure(UnknownException(e.toString(), raw: e));
    }
  }

  Future<MultipartFile> _toMultipartFile(dynamic file) async {
    if (file is MultipartFile) return file;
    if (file is File) {
      return MultipartFile.fromFile(file.path,
          filename: file.path.split('/').last);
    }
    if (file is String) {
      return MultipartFile.fromFile(file,
          filename: file.split('/').last);
    }
    throw ArgumentError('Unsupported file type');
  }
}

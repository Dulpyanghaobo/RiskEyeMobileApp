import 'package:dio/dio.dart';

enum AppErrorType { network, timeout, response, unknown }

class AppException implements Exception {
  final String message;
  final AppErrorType type;
  final int? code;

  AppException(this.message, {this.type = AppErrorType.unknown, this.code});

  factory AppException.fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return AppException('请求超时', type: AppErrorType.timeout);
      case DioExceptionType.badResponse:
        return AppException('服务器错误',
            type: AppErrorType.response, code: error.response?.statusCode);
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return AppException('网络异常', type: AppErrorType.network);
      case DioExceptionType.cancel:
        return AppException('请求取消');
      default:
        return AppException(error.message ?? '未知错误');
    }
  }

  @override
  String toString() => message;
}

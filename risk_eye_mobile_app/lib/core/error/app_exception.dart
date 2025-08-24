import 'package:dio/dio.dart';

/// Base class for all application exceptions.
class AppException implements Exception {
  final String message;
  final int? code;
  final dynamic raw;

  const AppException(this.message, {this.code, this.raw});

  @override
  String toString() => message;

  factory AppException.fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(error.message ?? '连接超时', raw: error);
      case DioExceptionType.badResponse:
        final status = error.response?.statusCode;
        if (status == 401) {
          return AuthException('未授权', code: status, raw: error);
        }
        return ServerException('服务器错误', code: status, raw: error);
      case DioExceptionType.cancel:
        return CancelException('请求已取消', raw: error);
      case DioExceptionType.connectionError:
        return NetworkException('网络异常', raw: error);
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return UnknownException(error.message ?? '未知错误', raw: error);
    }
  }
}

class NetworkException extends AppException {
  const NetworkException(String message, {int? code, dynamic raw})
      : super(message, code: code, raw: raw);
}

class ServerException extends AppException {
  const ServerException(String message, {int? code, dynamic raw})
      : super(message, code: code, raw: raw);
}

class AuthException extends AppException {
  const AuthException(String message, {int? code, dynamic raw})
      : super(message, code: code, raw: raw);
}

class TimeoutException extends AppException {
  const TimeoutException(String message, {int? code, dynamic raw})
      : super(message, code: code, raw: raw);
}

class CancelException extends AppException {
  const CancelException(String message, {int? code, dynamic raw})
      : super(message, code: code, raw: raw);
}

class ParseException extends AppException {
  const ParseException(String message, {int? code, dynamic raw})
      : super(message, code: code, raw: raw);
}

class UnknownException extends AppException {
  const UnknownException(String message, {int? code, dynamic raw})
      : super(message, code: code, raw: raw);
}

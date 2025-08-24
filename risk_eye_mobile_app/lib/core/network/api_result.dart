import '../error/app_exception.dart';

/// Wrapper for API call results.
class ApiResult<T> {
  final T? data;
  final AppException? error;

  const ApiResult._({this.data, this.error});

  bool get isSuccess => error == null;

  static ApiResult<T> success<T>(T data) => ApiResult._(data: data);

  static ApiResult<T> failure<T>(AppException error) =>
      ApiResult._(error: error);

  R when<R>({required R Function(T data) success, required R Function(AppException e) failure}) {
    if (isSuccess) {
      return success(data as T);
    }
    return failure(error!);
  }
}

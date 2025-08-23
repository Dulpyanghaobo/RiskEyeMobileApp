import 'package:dio/dio.dart';

import '../core/network/dio_client.dart';
import '../models/loan_score.dart';
import '../core/error/app_exception.dart';

class LoanRepository {
  final DioClient _client;
  LoanRepository(this._client);

  Future<LoanScore> getLatestScore(String userId) async {
    try {
      final res = await _client.client
          .get('/loan/score/latest', queryParameters: {'userId': userId});
      return LoanScore.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : AppException.fromDio(e);
    }
  }

  Future<LoanScore> triggerScore(String userId) async {
    try {
      final res = await _client.client
          .post('/loan/score/trigger', data: {'userId': userId});
      return LoanScore.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error is AppException
          ? e.error as AppException
          : AppException.fromDio(e);
    }
  }
}

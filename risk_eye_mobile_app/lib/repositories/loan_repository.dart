import '../core/network/api_result.dart';
import '../core/network/dio_client.dart';
import '../models/score_resp.dart';

class LoanRepository {
  final DioClient _client;
  LoanRepository(this._client);

  Future<ApiResult<ScoreResp>> getLatestScore(String userId) {
    return _client.get<ScoreResp>(
      '/loan/score/latest',
      query: {'userId': userId},
      parser: (json) => ScoreResp.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResult<ScoreResp>> triggerScore(String userId) {
    return _client.post<ScoreResp>(
      '/loan/score/trigger',
      data: {'userId': userId},
      parser: (json) => ScoreResp.fromJson(json as Map<String, dynamic>),
    );
  }
}

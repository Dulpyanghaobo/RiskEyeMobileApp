import '../models/score_result.dart';

/// Placeholder scoring engine.
class ScoringEngine {
  Future<ScoreResult> evaluate() async {
    // TODO: Implement scoring logic.
    return const ScoreResult(
      score: 720,
      grade: '高',
      decision: '通过',
      modelVersion: 'v1.2',
      strengths: ['收入稳定', '流水连续'],
      risks: ['近3月消费波动偏高'],
      reasonCodes: [ReasonCode(code: 'D001', desc: '负债率低')],
    );
  }
}

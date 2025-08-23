import 'package:flutter/foundation.dart';

@immutable
class ScoreResult {
  const ScoreResult({
    required this.score,
    required this.grade,
    required this.decision,
    required this.modelVersion,
    required this.strengths,
    required this.risks,
    required this.reasonCodes,
  });

  final int score;
  final String grade;
  final String decision;
  final String modelVersion;
  final List<String> strengths;
  final List<String> risks;
  final List<ReasonCode> reasonCodes;

  factory ScoreResult.fromJson(Map<String, dynamic> json) {
    return ScoreResult(
      score: json['score'] as int,
      grade: json['grade'] as String,
      decision: json['decision'] as String,
      modelVersion: json['modelVersion'] as String,
      strengths: List<String>.from(json['strengths'] as List),
      risks: List<String>.from(json['risks'] as List),
      reasonCodes: (json['reasonCodes'] as List)
          .map((e) => ReasonCode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'score': score,
        'grade': grade,
        'decision': decision,
        'modelVersion': modelVersion,
        'strengths': strengths,
        'risks': risks,
        'reasonCodes': reasonCodes.map((e) => e.toJson()).toList(),
      };
}

@immutable
class ReasonCode {
  const ReasonCode({required this.code, required this.desc});

  final String code;
  final String desc;

  factory ReasonCode.fromJson(Map<String, dynamic> json) =>
      ReasonCode(code: json['code'] as String, desc: json['desc'] as String);

  Map<String, dynamic> toJson() => {'code': code, 'desc': desc};
}

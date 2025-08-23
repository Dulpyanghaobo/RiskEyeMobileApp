// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_score.dart';

LoanScore _$LoanScoreFromJson(Map<String, dynamic> json) => LoanScore(
      score: (json['score'] as num).toDouble(),
      decision: $enumDecode(_$DecisionEnumMap, json['decision']),
      modelVersion: json['modelVersion'] as String,
      reasonCodes:
          (json['reasonCodes'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$LoanScoreToJson(LoanScore instance) => <String, dynamic>{
      'score': instance.score,
      'decision': _$DecisionEnumMap[instance.decision]!,
      'modelVersion': instance.modelVersion,
      'reasonCodes': instance.reasonCodes,
      'created_at': instance.createdAt.toIso8601String(),
    };

const Map<Decision, String> _$DecisionEnumMap = {
  Decision.approve: 'approve',
  Decision.review: 'review',
  Decision.reject: 'reject',
};


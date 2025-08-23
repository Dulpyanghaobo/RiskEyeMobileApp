import 'package:json_annotation/json_annotation.dart';

part 'loan_score.g.dart';

enum Decision { approve, review, reject }

@JsonSerializable()
class LoanScore {
  final double score;
  final Decision decision;
  final String modelVersion;
  final List<String> reasonCodes;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  LoanScore({
    required this.score,
    required this.decision,
    required this.modelVersion,
    required this.reasonCodes,
    required this.createdAt,
  });

  factory LoanScore.fromJson(Map<String, dynamic> json) =>
      _$LoanScoreFromJson(json);
  Map<String, dynamic> toJson() => _$LoanScoreToJson(this);
}

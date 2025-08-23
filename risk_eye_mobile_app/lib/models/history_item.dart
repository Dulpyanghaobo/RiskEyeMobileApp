import 'package:flutter/foundation.dart';
import 'upload_sources.dart';

@immutable
class HistoryItem {
  const HistoryItem({
    required this.id,
    required this.createdAt,
    required this.score,
    required this.grade,
    required this.decision,
    required this.reasonCodes,
    required this.sources,
    required this.modelVersion,
  });

  final String id;
  final DateTime createdAt;
  final int score;
  final String grade;
  final String decision;
  final List<String> reasonCodes;
  final UploadSources sources;
  final String modelVersion;

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      score: json['score'] as int,
      grade: json['grade'] as String,
      decision: json['decision'] as String,
      reasonCodes: List<String>.from(json['reasonCodes'] as List),
      sources: UploadSources.fromJson(json['sources'] as Map<String, dynamic>),
      modelVersion: json['modelVersion'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'score': score,
        'grade': grade,
        'decision': decision,
        'reasonCodes': reasonCodes,
        'sources': sources.toJson(),
        'modelVersion': modelVersion,
      };
}

class ScoreResp {
  final double score;
  final String grade;

  ScoreResp({required this.score, required this.grade});

  factory ScoreResp.fromJson(Map<String, dynamic> json) {
    return ScoreResp(
      score: (json['score'] as num).toDouble(),
      grade: json['grade'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'score': score,
        'grade': grade,
      };
}

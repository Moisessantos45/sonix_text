class EntityStats {
  final int totalGrades;
  final int completedGrades;
  final int score;
  final int remainingPoints;

  EntityStats({
    required this.totalGrades,
    required this.completedGrades,
    required this.score,
    required this.remainingPoints,
  });

  EntityStats copyWith({
    int? totalGrades,
    int? completedGrades,
    int? score,
    int? remainingPoints,
  }) {
    return EntityStats(
      totalGrades: totalGrades ?? this.totalGrades,
      completedGrades: completedGrades ?? this.completedGrades,
      score: score ?? this.score,
      remainingPoints: remainingPoints ?? this.remainingPoints,
    );
  }
}

class EntityLevel {
  final String id;
  final String title;
  final int level;
  final int point;
  final int multiplier;
  final String message;
  final bool isClaimed;

  EntityLevel({
    required this.id,
    required this.title,
    required this.level,
    required this.point,
    required this.multiplier,
    required this.message,
    this.isClaimed = false,
  });
}

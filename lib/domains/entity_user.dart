class EntityUser {
  final String id;
  final String name;
  final String nickname;
  final int level;

  EntityUser({
    required this.id,
    required this.name,
    required this.nickname,
    this.level = 1,
  });
}

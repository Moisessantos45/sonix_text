class EntityUser {
  final String id;
  final String name;
  final String nickname;
  final int level;
  final int hora;
  final int minuto;
  final bool activeNotifications;
  final String avatar;

  EntityUser({
    required this.id,
    required this.name,
    required this.nickname,
    this.level = 1,
    this.hora = 0,
    this.minuto = 0,
    this.activeNotifications = false,
    this.avatar = '92574792835600d793',
  });
}

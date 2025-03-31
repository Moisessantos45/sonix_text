import 'package:sonix_text/domains/entity_user.dart';

class UserModel extends EntityUser {
  UserModel({
    required super.id,
    required super.name,
    required super.nickname,
    required super.level,
    required super.hora,
    required super.minuto,
    required super.activeNotifications,
    required super.avatar,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      nickname: map['nickname'],
      level: map['level'],
      hora: map['hora'] ?? 0,
      minuto: map['minuto'] ?? 0,
      activeNotifications: map['active_notifications'] ?? false,
      avatar: map['avatar'] ?? '92574792835600d793',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nickname': nickname,
      'level': level,
      'hora': hora,
      'minuto': minuto,
      'active_notifications': activeNotifications.toString(),
      'avatar': avatar,
    };
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'nickname': nickname,
      'level': level,
      'hora': hora,
      'minuto': minuto,
      'active_notifications': activeNotifications.toString(),
      'avatar': avatar,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? nickname,
    int? level,
    int? hora,
    int? minuto,
    bool? activeNotifications,
    String? avatar,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      level: level ?? this.level,
      hora: hora ?? this.hora,
      minuto: minuto ?? this.minuto,
      activeNotifications: activeNotifications ?? this.activeNotifications,
      avatar: avatar ?? this.avatar,
    );
  }
}

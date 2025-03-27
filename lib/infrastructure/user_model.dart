import 'package:sonix_text/domains/entity_user.dart';

class UserModel extends EntityUser {
  UserModel({
    required super.id,
    required super.name,
    required super.nickname,
    required super.level,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      nickname: map['nickname'],
      level: map['level'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nickname': nickname,
      'level': level,
    };
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'nickname': nickname,
      'level': level,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? nickname,
    int? level,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      level: level ?? this.level,
    );
  }
}

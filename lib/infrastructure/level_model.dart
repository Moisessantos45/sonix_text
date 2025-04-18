import 'package:sonix_text/domains/entity_level.dart';

class LevelModel extends EntityLevel {
  LevelModel({
    required super.id,
    required super.title,
    required super.level,
    required super.point,
    required super.multiplier,
    required super.message,
    required super.isClaimed,
  });

  factory LevelModel.fromMap(Map<String, dynamic> map) {
    return LevelModel(
      id: map['id'],
      title: map['title'],
      level: map['level'],
      point: map['point'],
      multiplier: map['multiplier'],
      message: map['message'],
      isClaimed: map['isClaimed'] == "true",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'level': level,
      'point': point,
      'multiplier': multiplier,
      'message': message,
      "isClaimed": isClaimed.toString()
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      'title': title,
      'level': level,
      'point': point,
      'multiplier': multiplier,
      'message': message,
      "isClaimed": isClaimed.toString()
    };
  }

  Map<String, dynamic> toMapClaimed() {
    return {
      "isClaimed": isClaimed.toString()
    };
  }

  LevelModel copyWith({
    String? id,
    String? title,
    int? level,
    int? point,
    int? multiplier,
    String? message,
    bool? isClaimed,
  }) {
    return LevelModel(
      id: id ?? this.id,
      title: title ?? this.title,
      level: level ?? this.level,
      point: point ?? this.point,
      multiplier: multiplier ?? this.multiplier,
      message: message ?? this.message,
      isClaimed: isClaimed ?? this.isClaimed,
    );
  }

  int calculatePoints(int completedTasks) {
    return completedTasks * multiplier;
  }
}

import 'package:flutter/material.dart';

class EntityCard {
  final int id;
  final String title;
  final String subTitle;
  final String content;
  final IconData icon;
  final int primaryColor;
  final int secundaryColor;

  EntityCard(
      {required this.id,
      required this.title,
      required this.subTitle,
      required this.content,
      required this.icon,
      required this.primaryColor,
      required this.secundaryColor});

  EntityCard copyWith({
    int? id,
    String? title,
    String? subTitle,
    String? content,
    IconData? icon,
    int? primaryColor,
    int? secundaryColor,
  }) {
    return EntityCard(
      id: id ?? this.id,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      content: content ?? this.content,
      icon: icon ?? this.icon,
      primaryColor: primaryColor ?? this.primaryColor,
      secundaryColor: secundaryColor ?? this.secundaryColor,
    );
  }
}

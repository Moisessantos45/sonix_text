import 'package:flutter/material.dart';

class EntityCard {
  final String title;
  final String subTitle;
  final String content;
  final IconData icon;
  final int primaryColor;
  final int secundaryColor;

  EntityCard(
      {required this.title,
      required this.subTitle,
      required this.content,
      required this.icon,
      required this.primaryColor,
      required this.secundaryColor});
}

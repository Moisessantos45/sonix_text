import 'package:flutter/material.dart';
import 'package:sonix_text/domains/entity_card.dart';

final List<EntityCard> listCard = [
  EntityCard(
      title: "1",
      subTitle: "Notas Totales",
      content: "Total de notas creadas",
      icon: Icons.note,
      primaryColor: 0xFF3498DB,
      secundaryColor: 0xFF2980B9),
  EntityCard(
      title: "2",
      subTitle: "Completadas",
      content: "Tareas finalizadas",
      icon: Icons.task_alt,
      primaryColor: 0xFF2ECC71,
      secundaryColor: 0xFF27AE60),
  EntityCard(
      title: "320",
      subTitle: "Puntos Totales",
      content: "Puntos acumulados",
      icon: Icons.stars,
      primaryColor: 0xFFF39C12,
      secundaryColor: 0xFFE67E22),
  EntityCard(
      title: "180",
      subTitle: "Para Recompensa",
      content: "Puntos para siguiente nivel",
      icon: Icons.card_giftcard,
      primaryColor: 0xFF9B59B6,
      secundaryColor: 0xFF8E44AD),
];

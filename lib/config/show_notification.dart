import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';

void resetStyle({bool error = false}) {
  InAppNotifications.instance
    ..titleFontSize = 16.0
    ..descriptionFontSize = 14.0
    ..textColor = error
        ? const Color(0xFFffffff)
        : const Color.fromARGB(255, 255, 255, 255)
    ..backgroundColor = error ? const Color(0xFFf60055) : Colors.blue
    ..shadow = true
    ..animationStyle = InAppNotificationsAnimationStyle.scale;
}

void showNotification(String title, String description, {bool error = false}) {
  resetStyle(error: error);
  InAppNotifications.show(
      title: title,
      leading: error ? const Icon(Icons.error) : const Icon(Icons.check),
      description: description,
      onTap: () {},
      persistent: false,
      duration: const Duration(seconds: 3));
}

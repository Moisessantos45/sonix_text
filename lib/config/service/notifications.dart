import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationsService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void onDidReceiveNotificationResponse(
      NotificationResponse response) async {
    final context = navigatorKey.currentContext;
    if (context != null && response.payload != null) {
      try {
        final payload = jsonDecode(response.payload!);
        if (payload['type'] == 'update') {
          GoRouter.of(context).push('/about');
        }
      } catch (e) {
        debugPrint('Error procesando payload de notificación: $e');
      }
    }
  }

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveNotificationResponse,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    await _createNotificationChannels();
  }

  static Future<void> _createNotificationChannels() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          'update_channel',
          'Actualizaciones',
          importance: Importance.high,
          description: 'Notificaciones sobre nuevas versiones',
        ));

    // Canal general
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          'general_channel',
          'General',
          importance: Importance.defaultImportance,
          description: 'Notificaciones generales',
        ));
  }

  static Future<void> hideNotification(String title, String body) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
    ));

    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);
  }

  static Future<void> hideNotificationSchedule(
      int id, String title, String body, DateTime scheduleDate) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
    ));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduleDate, tz.local),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> showUpdateNotification({
    required int id,
    required String title,
    required String body,
    DateTime? scheduleDate,
    String version = '1.6.65',
  }) async {
    final androidDetails = const AndroidNotificationDetails(
      'update_channel',
      'Actualizaciones',
      channelDescription: 'Notificaciones sobre nuevas versiones',
      importance: Importance.high,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
    );

    final iosDetails = const DarwinNotificationDetails(
      categoryIdentifier: 'update',
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final payload = jsonEncode({
      'type': 'update',
      'version': version,
      'timestamp': DateTime.now().toIso8601String(),
    });

    if (scheduleDate != null) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduleDate, tz.local),
        details,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } else {
      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        details,
        payload: payload,
      );
    }
  }

  static Future<void> cancel(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}


Future<void> requestNotificationPermissions() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Obtener la implementación específica para Android
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      // 1. Solicitar el permiso POST_NOTIFICATIONS (para Android 13+)
      final bool? grantedNotifications =
          await androidImplementation.requestNotificationsPermission();
      if (grantedNotifications == null || !grantedNotifications) {
        debugPrint('Permiso de notificaciones denegado o no concedido.');
        // Opcional: Considera mostrar un diálogo al usuario para explicar por qué necesita el permiso
        // y cómo puede activarlo desde la configuración de la app.
      }

      // 2. Solicitar el permiso SCHEDULE_EXACT_ALARM (para Android 12+ al usar exactAllowWhileIdle)
      final bool? grantedExactAlarms =
          await androidImplementation.requestExactAlarmsPermission();
      if (grantedExactAlarms == null || !grantedExactAlarms) {
        debugPrint('Permiso de alarmas exactas denegado o no concedido.');
        // Opcional: Similar al anterior, informa al usuario si este permiso es crítico.
      }
    }
  }
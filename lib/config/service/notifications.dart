import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationsService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {}

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

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveNotificationResponse,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
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

  static Future<void> cancel(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

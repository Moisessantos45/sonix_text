import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:sonix_text/presentation/utils/parse_date.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(settings);

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> scheduleNotification(
      String title, String body, DateTime dueDate) async {
    tz.initializeTimeZones();

    final dueDateAt4AM = tz.TZDateTime.from(dueDate, tz.local)
        .subtract(
          Duration(
              hours: dueDate.hour,
              minutes: dueDate.minute,
              seconds: dueDate.second),
        )
        .add(Duration(hours: 8));

    await _notificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      dueDateAt4AM,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          importance: Importance.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}

Database? _db;

Future<void> startBackgroundService(Database db) async {
  final service = FlutterBackgroundService();
  _db = db;

  final isStart = await service.isRunning();
  if (isStart) {
    service.invoke("stop");
    await Future.delayed(const Duration(milliseconds: 500));
  }

  await service.configure(
    androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        autoStartOnBoot: true,
        isForegroundMode: true,
        initialNotificationTitle: "Servicio en segundo plano"),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

void onStart(ServiceInstance service) async {
  if (_db == null) {
    print("Error: Database is null");
    return;
  }

  try {
    final List<Map<String, dynamic>> tasks =
        await _db!.rawQuery("SELECT * FROM grade");

    final today = DateTime.now();
    final fiveDaysFromNow = today.add(Duration(days: 5));
    for (var task in tasks) {
      print(
          'Tarea: ${task['title']} - Fecha de vencimiento: ${task['due_date']}');
      try {
        DateTime dueDate = parseDate(task['due_date']);

        if (dueDate.isAfter(today) && dueDate.isBefore(fiveDaysFromNow)) {
          NotificationService().scheduleNotification(
            'Tarea pendiente',
            'La tarea "${task['title']}" está próxima a vencer el ${dueDate.day}/${dueDate.month}.',
            dueDate,
          );

          for (int i = 1; i <= 5; i++) {
            final notificationDate = today.add(Duration(days: i));
            if (notificationDate.isBefore(dueDate)) {
              NotificationService().scheduleNotification(
                'Tarea pendiente',
                'La tarea "${task['title']}" está próxima a vencer el ${dueDate.day}/${dueDate.month}.',
                notificationDate,
              );
            }
          }
        }
      } catch (e) {
        print("Error al programar la notificación: $e");
        throw e;
      }
    }
  } catch (e) {
    print("ocurrio un error $e");
  }
}

bool onIosBackground(ServiceInstance service) {
  return true;
}

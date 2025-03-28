import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:sonix_text/config/helper/start_background_service.dart';
import 'package:sonix_text/config/db.dart';
import 'package:sonix_text/config/router/router.dart';
import 'package:sonix_text/presentation/riverpod/repository_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await initializeDatabase();

  await startBackgroundService();
  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sonix Text',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        useMaterial3: true,
      ),
      routerConfig: appRouter,
      builder: InAppNotifications.init(),
    );
  }
}

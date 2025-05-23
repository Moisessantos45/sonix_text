import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:lottie/lottie.dart';
import 'package:sonix_text/config/service/notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sonix_text/config/db.dart';
import 'package:sonix_text/config/router/router.dart';
import 'package:sonix_text/presentation/riverpod/repository_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const SplashScreen());
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = await initializeDatabase();
    await dotenv.load(fileName: '.env');
    await NotificationsService.init();
    tz.initializeTimeZones();
    await Future.delayed(const Duration(seconds: 3));

    runApp(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
        ],
        child: const MyApp(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: Lottie.asset('assets/lottle/1745961873622.json',
              width: 200, height: 200),
        ),
      ),
    );
  }
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

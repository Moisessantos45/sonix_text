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
    try {
      WidgetsFlutterBinding.ensureInitialized();

      // Inicializar la base de datos primero ya que se necesita para el ProviderScope
      final database = await initializeDatabase();

      // Inicializar el resto de servicios en paralelo ya que no dependen entre sí
      await Future.wait([
        dotenv.load(fileName: '.env'),
        NotificationsService.init(),
        Future(() => tz.initializeTimeZones()),
        Future.delayed(const Duration(seconds: 3)),
      ]);

      runApp(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(database),
          ],
          child: const MyApp(),
        ),
      );
    } catch (e) {
      debugPrint('Error durante la inicialización de la app: $e');
      runApp(
        MaterialApp(
          home: Scaffold(
            backgroundColor: Color(0xff0dc1fe),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Error al iniciar la aplicación',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xff0dc1fe),
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
        primaryColor: const Color(0xff0dc1fe),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final modifiedMediaQuery = mediaQuery.copyWith(
          textScaler: mediaQuery.textScaler.scale(1.0) > 1.3
              ? const TextScaler.linear(1.05)
              : mediaQuery.textScaler,
        );

        return MediaQuery(
          data: modifiedMediaQuery,
          child: InAppNotifications.init()(context, child),
        );
      },
    );
  }
}

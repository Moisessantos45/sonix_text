import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:lottie/lottie.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sonix_text/config/config.dart';
import 'package:sonix_text/presentation/riverpod/repository_db.dart';
import 'package:sonix_text/presentation/utils/generate_id.dart';

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

      final database = await initializeDatabase();
      final sharedPrefs = SharedPreferentsManager();
      final versionApi = VersionApi(
        sharedPreferents: sharedPrefs,
        defaultVersion: '1.0.0',
      );

      await Future.wait([
        dotenv.load(fileName: '.env'),
        NotificationsService.init(),
        Future(() => tz.initializeTimeZones()),
      ]);

      _checkVersion(versionApi);

      await Future.delayed(const Duration(seconds: 3));

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
            backgroundColor: const Color(0xff0dc1fe),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
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

  Future<void> _checkVersion(VersionApi versionApi) async {
    try {
      final versionCode = await versionApi.getVersionDevice();
      final dio = Dio();

      final response = await dio.get(
        '${dotenv.env['API_URL']}/version-check',
        queryParameters: {
          'app': 'sonix_text-$versionCode',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['data'] != null) {
          await NotificationsService.showUpdateNotification(
            id: generateUniqueId(),
            title: "Actualización disponible",
            body:
                'Una nueva versión de Sonix Text está disponible. Por favor, actualiza la aplicación.',
            scheduleDate: DateTime.now().add(const Duration(seconds: 5)),
            version: data['data']['codeVersion'],
          );
        }
      }
    } catch (e) {
      debugPrint('Error al verificar la versión: $e');
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
          textScaler: mediaQuery.textScaler.scale(1.0) > 1.1
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

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sonix_text/config/helper/shared_preferents.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sonix_text/config/show_notification.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final sharedPreferents = SharedPreferentsManager();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  String API_URL = dotenv.env['API_URL'] ?? '';
  bool _downloading = false;
  String versionCode = "1.5.25";

  Future<void> _initializeVersion() async {
    try {
      final version = await sharedPreferents.getCodeVersion("version_code");
      if (version == "0.0.0") {
        await sharedPreferents.saveCodeVersion("version_code", versionCode);
      } else {
        setState(() {
          versionCode = version;
        });
      }
    } catch (e) {
      await sharedPreferents.saveCodeVersion("version_code", versionCode);
    }
  }

  Future<void> getVersionDevice() async {
    try {
      final version = await sharedPreferents.getCodeVersion("version_code");
      if (version == "0.0.0") {
        await sharedPreferents.saveCodeVersion("version_code", versionCode);
        return;
      }
      setState(() {
        versionCode = version;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> downloadAPK() async {
    setState(() => _downloading = true);
    try {
      await getVersionDevice();
      final dio = Dio();
      final response = await dio.post(
        API_URL,
        queryParameters: {
          'app': 'sonix_text-$versionCode',
        },
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode != 200) {
        throw Exception("Error al descargar el APK");
      }

      final appName =
          response.headers.value('x-app-name') ?? 'sonix_text-$versionCode.apk';
      final appVersion = appName.split("-").last.replaceFirst(".apk", "");
      await sharedPreferents.saveCodeVersion("version_code", appVersion);

      final directory = await getExternalStorageDirectory();
      final filePath = '${directory?.path}/$appName';
      final file = File(filePath);

      await file.writeAsBytes(response.data);
      showNotification("APK descargado", "APK descargado correctamente");
      await _installAPK(appName);

      setState(() {
        versionCode = appName.split("-").last.replaceFirst(".apk", "");
      });
    } catch (e) {
      showNotification("Error", "Error al descargar el APK", error: true);
    } finally {
      setState(() => _downloading = false);
    }
  }

  Future<void> _installAPK(String pathFile) async {
    final directory = await getExternalStorageDirectory();
    final filePath = '${directory?.path}/$pathFile';

    InstallPlugin.installApk(filePath, appId: 'com.example.sonix_text')
        .then((result) {
      print('Instalación iniciada: $result');
    }).catchError((error) {
      print('Error al iniciar instalación: $error');
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Acerca de',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF2C3E50)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline,
                  size: 64, color: Color(0xFF3498DB)),
              const SizedBox(height: 16),
              const Text(
                'Sonix Text',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Desarrollador: Moisés Santos',
                style: TextStyle(fontSize: 16, color: Color(0xFF2C3E50)),
              ),
              const SizedBox(height: 8),
              Text(
                'Versión: $versionCode',
                style: TextStyle(fontSize: 16, color: Color(0xFF2C3E50)),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {},
                child: const Text(
                  'GitHub: github.com/Moisessantos45',
                  style: TextStyle(
                    color: Color(0xFF3498DB),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _downloading ? null : downloadAPK,
                  icon: _downloading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.download),
                  label:
                      Text(_downloading ? 'Descargando...' : 'Descargar APK'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3498DB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

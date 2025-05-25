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
      final appVersion =
          response.headers.value('x-code-version') ?? versionCode;
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
        .then((result) {})
        .catchError((error) {
      showNotification("Error", "Error al instalar el APK", error: true);
    }).whenComplete(() {
      setState(() {
        _downloading = false;
      });
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(100),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.text_fields_rounded,
                      size: 80,
                      color: Color(0xFF3498DB),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Sonix Text',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Versión: $versionCode',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF7F8C8D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(100),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Desarrollador',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0xFF3498DB),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Moisés Santos',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: const [
                          Icon(
                            Icons.link,
                            color: Color(0xFF3498DB),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'github.com/Moisessantos45',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF3498DB),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(100),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Características',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    SizedBox(height: 12),
                    FeatureItem(
                      icon: Icons.record_voice_over,
                      title: 'Reconocimiento de voz',
                      description:
                          'Convierte tu voz en texto de forma rápida y precisa',
                    ),
                    SizedBox(height: 12),
                    FeatureItem(
                      icon: Icons.text_format,
                      title: 'Editor de texto',
                      description: 'Editor intuitivo con funciones esenciales',
                    ),
                    SizedBox(height: 12),
                    FeatureItem(
                      icon: Icons.save_alt,
                      title: 'Guardado automático',
                      description: 'Tus notas se guardan automáticamente',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
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
                      : const Icon(Icons.download,color: Colors.white),
                  label: Text(
                      _downloading
                          ? 'Descargando...'
                          : 'Descargar última versión',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3498DB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
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

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF3498DB).withAlpha(100),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF3498DB),
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF2C3E50).withAlpha(400),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

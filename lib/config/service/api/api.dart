import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sonix_text/config/config.dart';
import 'package:sonix_text/config/helper/shared_preferents.dart';
import 'package:sonix_text/presentation/utils/generate_id.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VersionApi {
  final SharedPreferentsManager _sharedPreferents;
  final String _defaultVersion;

  VersionApi({
    required SharedPreferentsManager sharedPreferents,
    required String defaultVersion,
  })  : _sharedPreferents = sharedPreferents,
        _defaultVersion = defaultVersion;

  Future<String> initializeVersion() async {
    try {
      final version = await _sharedPreferents.getCodeVersion("version_code");
      if (version == "0.0.0") {
        await _sharedPreferents.saveCodeVersion(
            "version_code", _defaultVersion);
        return _defaultVersion;
      }
      return version;
    } catch (e) {
      await _sharedPreferents.saveCodeVersion("version_code", _defaultVersion);
      return _defaultVersion;
    }
  }

  Future<String> getVersionDevice() async {
    try {
      final version = await _sharedPreferents.getCodeVersion("version_code");
      if (version == "0.0.0") {
        await _sharedPreferents.saveCodeVersion(
            "version_code", _defaultVersion);
        return _defaultVersion;
      }
      return version;
    } catch (e) {
      throw Exception(e);
    }
  }
}

Future<void> checkVersion(VersionApi versionApi) async {
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

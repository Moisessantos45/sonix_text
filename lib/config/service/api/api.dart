import 'package:sonix_text/config/helper/shared_preferents.dart';

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

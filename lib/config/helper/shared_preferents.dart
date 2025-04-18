import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferentsManager {
  static final SharedPreferentsManager _instance =
      SharedPreferentsManager._internal();
  factory SharedPreferentsManager() => _instance;
  SharedPreferentsManager._internal();

  Future<bool> getData(String key) async {
    try {
      final pref = await SharedPreferences.getInstance();
      return pref.getBool(key) ?? false;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> getCodeVersion(String key) async {
    try {
      final pref = await SharedPreferences.getInstance();
      return pref.getString(key) ?? "0.0.0";
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> saveData(String key, bool value) async {
    try {
      final pref = await SharedPreferences.getInstance();
      await pref.setBool(key, value);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> saveCodeVersion(String key, String value) async {
    try {
      final pref = await SharedPreferences.getInstance();
      await pref.setString(key, value);
    } catch (e) {
      throw Exception(e);
    }
  }
}

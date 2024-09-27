import 'package:firebase_local_config/source/config_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesConfigSource extends ConfigSource {
  late final SharedPreferences _preferences;

  @override
  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  @override
  bool? getBool(String key) => _preferences.getBool(key);

  @override
  double? getDouble(String key) => _preferences.getDouble(key);

  @override
  int? getInt(String key) => _preferences.getInt(key);

  @override
  String? getString(String key) => _preferences.getString(key);

  @override
  Future<void> setBool(String key, bool value) async {
    await _preferences.setBool(key, value);
  }

  @override
  Future<void> setDouble(String key, double value) async {
    await _preferences.setDouble(key, value);
  }

  @override
  Future<void> setInt(String key, int value) async {
    await _preferences.setInt(key, value);
  }

  @override
  Future<void> setString(String key, String value) async {
    await _preferences.setString(key, value);
  }
}

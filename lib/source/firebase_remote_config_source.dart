import 'package:firebase_local_config/source/config_source.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigSource extends ConfigSource {
  final _firebaseRemoteConfig = FirebaseRemoteConfig.instance;

  @override
  Future<void> initialize() async {}

  @override
  bool? getBool(String key) {
    if (_isValueStatic(key)) return null;
    return _firebaseRemoteConfig.getBool(key);
  }

  @override
  double? getDouble(String key) {
    if (_isValueStatic(key)) return null;
    return _firebaseRemoteConfig.getDouble(key);
  }

  @override
  int? getInt(String key) {
    if (_isValueStatic(key)) return null;
    return _firebaseRemoteConfig.getInt(key);
  }

  @override
  String? getString(String key) {
    if (_isValueStatic(key)) return null;
    return _firebaseRemoteConfig.getString(key);
  }

  bool _isValueStatic(String key) {
    final value = _firebaseRemoteConfig.getValue(key);
    return value.source == ValueSource.valueStatic;
  }

  @override
  Future<void> setBool(String key, bool value) async {}

  @override
  Future<void> setDouble(String key, double value) async {}

  @override
  Future<void> setInt(String key, int value) async {}

  @override
  Future<void> setString(String key, String value) async {}
}

library firebase_local_config;

import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteLocalConfig {
  FirebaseRemoteLocalConfig._();

  static final FirebaseRemoteLocalConfig instance =
      FirebaseRemoteLocalConfig._();

  final FirebaseRemoteConfig _firebaseRemoteConfig =
      FirebaseRemoteConfig.instance;

  bool getBool(String key) {
    return _firebaseRemoteConfig.getBool(key);
  }

  int getInt(String key) {
    return _firebaseRemoteConfig.getInt(key);
  }

  double getDouble(String key) {
    return _firebaseRemoteConfig.getDouble(key);
  }

  String getString(String key) {
    return getString(key);
  }
}

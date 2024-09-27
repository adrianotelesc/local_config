library firebase_local_config;

import 'package:firebase_local_config/source/config_source.dart';
import 'package:firebase_local_config/source/firebase_remote_config_source.dart';
import 'package:firebase_local_config/source/shared_preferences_config_source.dart';
import 'package:flutter/widgets.dart';

class ConfigManager {
  ConfigManager._();

  static final instance = ConfigManager._();

  final ConfigSource _remoteConfig = FirebaseRemoteConfigSource();

  final ConfigSource _localConfig = SharedPreferencesConfigSource();

  bool localConfigEnabled = false;

  Future<void> initialize() async {
    await _localConfig.initialize();
    await _remoteConfig.initialize();
  }

  bool? getBool(String key) {
    if (localConfigEnabled) {
      final localValue = _localConfig.getBool(key);
      if (localValue != null) {
        return localValue;
      }
    }

    return _remoteConfig.getBool(key);
  }

  int? getInt(String key) {
    if (localConfigEnabled) {
      final localValue = _localConfig.getInt(key);
      if (localValue != null) {
        return localValue;
      }
    }

    return _remoteConfig.getInt(key);
  }

  double? getDouble(String key) {
    if (localConfigEnabled) {
      final localValue = _localConfig.getDouble(key);
      if (localValue != null) {
        return localValue;
      }
    }

    return _remoteConfig.getDouble(key);
  }

  String? getString(String key) {
    if (localConfigEnabled) {
      final localValue = _localConfig.getString(key);
      if (localValue != null) {
        return localValue;
      }
    }

    return _remoteConfig.getString(key);
  }

  Future<void> setLocalBool(String key, bool value) async {
    if (localConfigEnabled) {
      await _localConfig.setBool(key, value);
    }
  }

  Future<void> setLocalInt(String key, int value) async {
    if (localConfigEnabled) {
      await _localConfig.setInt(key, value);
    }
  }

  Future<void> setLocalDouble(String key, double value) async {
    if (localConfigEnabled) {
      await _localConfig.setDouble(key, value);
    }
  }

  Future<void> setLocalString(String key, String value) async {
    if (localConfigEnabled) {
      await _localConfig.setString(key, value);
    }
  }

  Widget getLocalConfigScreen() {
    return const SizedBox.shrink();
  }
}

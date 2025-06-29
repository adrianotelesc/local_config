library local_config;

import 'dart:async';

import 'package:local_config/model/config_value.dart';
import 'package:flutter/material.dart';
import 'package:local_config/preferences/preferences_delegate.dart';
import 'package:local_config/preferences/shared_preferences_delegate.dart';
import 'package:local_config/screen/local_config_screen.dart';

class LocalConfig {
  LocalConfig._();

  static final instance = LocalConfig._();

  final PreferencesDelegate _preferencesDelegate = SharedPreferencesDelegate();

  final _configs = <String, ConfigValue>{};
  final _configsStreamController = StreamController<Map<String, ConfigValue>>();

  Future<void> initialize({required Map<String, ConfigValue> configs}) async {
    var configsInPreferences = await _preferencesDelegate.getAll();
    for (final key in configsInPreferences.keys) {
      if (!configs.containsKey(key)) {
        await _preferencesDelegate.removePreference(key);
      }
    }

    for (final config in configsInPreferences.entries) {
      configs[config.key] = ConfigValue(
        config.value.toString(),
      );
    }

    _configs.addAll(configs);
    _configsStreamController.add(_configs);
  }

  Future<bool?> getBool(String key) async {
    final config = await getString(key);
    if (config == null) return null;
    return bool.tryParse(config);
  }

  Future<int?> getInt(String key) async {
    final config = await getString(key);
    if (config == null) return null;
    return int.tryParse(config);
  }

  Future<double?> getDouble(String key) async {
    final config = await getString(key);
    if (config == null) return null;
    return double.tryParse(config);
  }

  Future<String?> getString(String key) async => _configs[key]?.asString;

  Future<void> setBool(String key, bool value) async {
    setString(key, value.toString());
  }

  Future<void> setInt(String key, int value) async {
    setString(key, value.toString());
  }

  Future<void> setDouble(String key, double value) async {
    setString(key, value.toString());
  }

  Future<void> setString(String key, String value) async {
    if (!_configs.containsKey(key)) return;
    _configs[key] = ConfigValue(value);
    _configsStreamController.add(_configs);
    await _preferencesDelegate.setPreference(key, value);
  }

  Widget getLocalConfigsScreen() => const LocalConfigScreen();

  Stream<Map<String, ConfigValue>> get configsStream =>
      _configsStreamController.stream;
}

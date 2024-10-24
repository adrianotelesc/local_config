library firebase_local_config;

import 'package:firebase_local_config/model/config_value.dart';
import 'package:flutter/material.dart';
import 'package:firebase_local_config/preferences/preferences_delegate.dart';
import 'package:firebase_local_config/preferences/shared_preferences_delegate.dart';
import 'package:firebase_local_config/widget/local_config_screen.dart';

class LocalConfig {
  LocalConfig._();

  static final instance = LocalConfig._();

  final PreferencesDelegate _preferencesDelegate = SharedPreferencesDelegate();

  final Map<String, ConfigValue> _configs = {};

  final Map<String, dynamic> _configsInPreferences = {};

  Future<void> initialize({required Map<String, ConfigValue> configs}) async {
    _configs.addAll(configs);

    var configsInPreferences = await _preferencesDelegate.getAll();
    for (final key in configsInPreferences.keys) {
      if (!_configs.containsKey(key)) {
        await _preferencesDelegate.removePreference(key);
        configsInPreferences.remove(key);
      }
    }
    _configsInPreferences.addAll(configsInPreferences);
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

  Future<String?> getString(String key) async =>
      _configsInPreferences[key] ?? _configs[key];

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
    _configsInPreferences[key] = value;
    await _preferencesDelegate.setPreference(key, value);
  }

  Widget getLocalConfigsScreen() {
    final configs = <String, ConfigValue>{..._configs};
    for (final config in _configsInPreferences.entries) {
      configs[config.key] = ConfigValue(
        value: config.value.toString(),
        valueType: configs[config.key]!.valueType,
      );
    }
    return LocalConfigScreen(configs: configs.entries.toList());
  }
}

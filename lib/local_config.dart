library local_config;

import 'dart:async';

import 'package:local_config/extension/string_parsing.dart';
import 'package:local_config/model/config.dart';
import 'package:flutter/material.dart';
import 'package:local_config/preferences/preferences_delegate.dart';
import 'package:local_config/preferences/shared_preferences_delegate.dart';
import 'package:local_config/screen/local_config_screen.dart';

class LocalConfig {
  LocalConfig._();

  static final instance = LocalConfig._();

  final PreferencesDelegate _preferencesDelegate = SharedPreferencesDelegate();

  final _configs = <String, Config>{};
  final _configsStreamController = StreamController<Map<String, Config>>();

  Future<void> initialize({required Map<String, Config> configs}) async {
    var configsInPreferences = await _preferencesDelegate.getAll();
    for (final key in configsInPreferences.keys) {
      if (!configs.containsKey(key)) {
        await _preferencesDelegate.removePreference(key);
      }
    }

    // for (final config in configsInPreferences.entries) {
    //   configs[config.key] = Config(
    //     value: config.value,
    //   );
    // }

    _configs.addAll(configs);
    _configsStreamController.add(_configs);
  }

  Future<bool?> getBool(String key) async {
    final config = await getString(key);
    return config?.asBool;
  }

  Future<int?> getInt(String key) async {
    final config = await getString(key);
    return config?.asInt;
  }

  Future<double?> getDouble(String key) async {
    final config = await getString(key);
    return config?.asDouble;
  }

  Future<String?> getString(String key) async => _configs[key]?.value;

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
    _configs[key] = Config(value: value);
    _configsStreamController.add(_configs);
    await _preferencesDelegate.setPreference(key, value);
  }

  Widget getLocalConfigsScreen() => const LocalConfigScreen();

  Stream<Map<String, Config>> get configsStream =>
      _configsStreamController.stream;
}

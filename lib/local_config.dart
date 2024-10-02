library firebase_local_config;

import 'package:firebase_local_config/preferences/preferences_delegate.dart';
import 'package:firebase_local_config/preferences/shared_preferences_delegate.dart';
import 'package:firebase_local_config/widget/config_screen.dart';
import 'package:flutter/material.dart';

class LocalConfig {
  LocalConfig._();

  static final instance = LocalConfig._();

  final PreferencesDelegate _preferencesDelegate = SharedPreferencesDelegate();

  Map<String, String> _configs = {};

  void initialize({required Map<String, String> configs}) {
    _configs = configs;
  }

  Future<bool?> getBool(String key) async {
    final config = await _preferencesDelegate.getPreference(key);
    if (config == null) return null;

    return bool.tryParse(config);
  }

  Future<int?> getInt(String key) async {
    final config = await _preferencesDelegate.getPreference(key);
    if (config == null) return null;

    return int.tryParse(config);
  }

  Future<double?> getDouble(String key) async {
    final config = await _preferencesDelegate.getPreference(key);
    if (config == null) return null;

    return double.tryParse(config);
  }

  Future<String?> getString(String key) async {
    return await _preferencesDelegate.getPreference(key);
  }

  Future<void> setBool(String key, bool value) async {
    if (!_configs.containsKey(key)) return;
    await _preferencesDelegate.setPreference(key, value.toString());
  }

  Future<void> setInt(String key, int value) async {
    if (!_configs.containsKey(key)) return;
    await _preferencesDelegate.setPreference(key, value.toString());
  }

  Future<void> setDouble(String key, double value) async {
    if (!_configs.containsKey(key)) return;
    await _preferencesDelegate.setPreference(key, value.toString());
  }

  Future<void> setString(String key, String value) async {
    if (!_configs.containsKey(key)) return;
    await _preferencesDelegate.setPreference(key, value.toString());
  }

  Widget getLocalConfigsScreen() {
    final configs = _configs.entries.toList();
    return LocalConfigScreen(configs: configs);
  }
}

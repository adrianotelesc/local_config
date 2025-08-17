library local_config;

import 'dart:async';

import 'package:local_config/di/service_locator.dart';
import 'package:local_config/repository/config_repository.dart';
import 'package:local_config/repository/default_config_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_config/extension/string_extension.dart';
import 'package:local_config/storage/shared_preferences_store.dart';

export 'package:local_config/ui/screen/local_config_screen.dart';

class LocalConfig {
  LocalConfig._();

  static final instance = LocalConfig._();

  Stream<Map<String, String>> get onConfigUpdated {
    final repo = ServiceLocator.get<ConfigRepository>();
    return repo.configsStream.map((configs) {
      return configs.map((key, config) => MapEntry(key, config.value));
    });
  }

  Future<void> initialize({required Map<String, String> configs}) async {
    final repo = DefaultConfigRepository(
      store: SharedPreferencesStore(
        sharedPreferencesAsync: SharedPreferencesAsync(),
      ),
    )..populate(all: configs);
    ServiceLocator.register<ConfigRepository>(repo);
  }

  Future<bool?> getBool(String key) async {
    final repo = ServiceLocator.get<ConfigRepository>();
    final config = await repo.get(key);
    return config?.value.asBool;
  }

  Future<int?> getInt(String key) async {
    final repo = ServiceLocator.get<ConfigRepository>();
    final config = await repo.get(key);
    return config?.value.asInt;
  }

  Future<double?> getDouble(String key) async {
    final repo = ServiceLocator.get<ConfigRepository>();
    final config = await repo.get(key);
    return config?.value.asDouble;
  }

  Future<String?> getString(String key) async {
    final repo = ServiceLocator.get<ConfigRepository>();
    final config = await repo.get(key);
    return config?.value;
  }
}

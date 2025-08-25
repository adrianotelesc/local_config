library local_config;

import 'dart:async';

import 'package:local_config/data/data_source/shared_preferences_data_source.dart';
import 'package:local_config/di/service_locator.dart';
import 'package:local_config/data/repository/default_config_repository.dart';
import 'package:local_config/data/repository/dummy_config_repository.dart';
import 'package:local_config/domain/repository/config_repository.dart';
import 'package:local_config/common/extension/string_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
export 'package:local_config/ui/screen/local_config_list_screen.dart';

class LocalConfig {
  static final instance = LocalConfig._();

  LocalConfig._() {
    ServiceLocator.register<ConfigRepository>(DummyConfigRepository());
  }

  Stream<Map<String, String>> get onConfigUpdated {
    final repo = ServiceLocator.locate<ConfigRepository>();
    return repo.configsStream.map((configs) {
      return configs.map((key, config) => MapEntry(key, config.value));
    });
  }

  Future<void> initialize({required Map<String, String> configs}) async {
    final repo = DefaultConfigRepository(
      store: SharedPreferencesDataSource(
        sharedPreferencesAsync: SharedPreferencesAsync(),
      ),
    )..populate(configs);
    ServiceLocator.register<ConfigRepository>(repo);
  }

  Future<bool?> getBool(String key) async {
    final repo = ServiceLocator.locate<ConfigRepository>();
    final config = await repo.get(key);
    return config?.value.asBool;
  }

  Future<int?> getInt(String key) async {
    final repo = ServiceLocator.locate<ConfigRepository>();
    final config = await repo.get(key);
    return config?.value.asInt;
  }

  Future<double?> getDouble(String key) async {
    final repo = ServiceLocator.locate<ConfigRepository>();
    final config = await repo.get(key);
    return config?.value.asDouble;
  }

  Future<String?> getString(String key) async {
    final repo = ServiceLocator.locate<ConfigRepository>();
    final config = await repo.get(key);
    return config?.value;
  }
}

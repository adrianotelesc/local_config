library local_config;

import 'dart:async';

import 'package:flutter/widgets.dart' show Widget;
import 'package:local_config/data/data_source/shared_preferences_data_source.dart';
import 'package:local_config/data/repository/default_config_repository.dart';
import 'package:local_config/data/repository/dummy_config_repository.dart';
import 'package:local_config/domain/data_source/key_value_data_source.dart';
import 'package:local_config/domain/repository/config_repository.dart';
import 'package:local_config/common/extension/string_extension.dart';
import 'package:local_config/infra/service_locator/get_it_service_locator.dart';
import 'package:local_config/ui/screen/local_config_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalConfig {
  static final instance = LocalConfig._();

  final _locator = GetItServiceLocator();

  LocalConfig._() {
    _locator.registerLazySingleton<ConfigRepository>(
      () => DummyConfigRepository(),
    );
  }

  Stream<Map<String, String>> get onConfigUpdated {
    final repo = _locator.locate<ConfigRepository>();
    return repo.configsStream.map((configs) {
      return configs.map((key, config) => MapEntry(key, config.value));
    });
  }

  Future<void> initialize({required Map<String, String> configs}) async {
    _locator.registerFactory(
      () => SharedPreferencesAsync(),
    );
    _locator.registerFactory<KeyValueDataSource>(
      () => SharedPreferencesDataSource(
        sharedPreferencesAsync: _locator.locate(),
      ),
    );

    _locator.unregister<ConfigRepository>();
    _locator.registerLazySingleton<ConfigRepository>(
      () => DefaultConfigRepository(
        dataSource: _locator.locate(),
      )..populate(configs),
    );
  }

  Future<bool?> getBool(String key) async {
    final repo = _locator.locate<ConfigRepository>();
    final config = await repo.get(key);
    return config?.value.asBool;
  }

  Future<int?> getInt(String key) async {
    final repo = _locator.locate<ConfigRepository>();
    final config = await repo.get(key);
    return config?.value.asInt;
  }

  Future<double?> getDouble(String key) async {
    final repo = _locator.locate<ConfigRepository>();
    final config = await repo.get(key);
    return config?.value.asDouble;
  }

  Future<String?> getString(String key) async {
    final repo = _locator.locate<ConfigRepository>();
    final config = await repo.get(key);
    return config?.value;
  }

  Widget get screen => LocalConfigListScreen(locator: _locator);
}

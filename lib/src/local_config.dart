import 'package:flutter/material.dart';
import 'package:local_config/src/common/extension/map_extension.dart';
import 'package:local_config/src/common/extension/string_extension.dart';
import 'package:local_config/src/data/manager/config_manager.dart';
import 'package:local_config/src/data/manager/default_config_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_config/src/core/di/service_locator.dart';
import 'package:local_config/src/core/storage/key_value_store.dart';
import 'package:local_config/src/data/data_source/default_key_value_data_source.dart';
import 'package:local_config/src/data/repository/default_config_repository.dart';
import 'package:local_config/src/data/repository/no_op_config_repository.dart';
import 'package:local_config/src/data/data_source/key_value_data_source.dart';
import 'package:local_config/src/domain/repository/config_repository.dart';
import 'package:local_config/src/infra/di/get_it_service_locator.dart';
import 'package:local_config/src/infra/storage/namespaced_key_value_store.dart';
import 'package:local_config/src/infra/storage/shared_preferences_key_value_store.dart';
import 'package:local_config/src/common/util/key_namespace.dart';
import 'package:local_config/src/ui/local_config_entrypoint.dart';

final class LocalConfig {
  static const _namespace = 'local_config';

  static final instance = LocalConfig._();

  final _serviceLocator = GetItServiceLocator();

  LocalConfig._() {
    _serviceLocator.registerLazySingleton<ConfigRepository>(
      () => NoOpConfigRepository(),
    );
  }

  void initialize({
    required Map<String, dynamic> parameters,
    KeyValueStore? keyValueStore,
  }) {
    _serviceLocator
      ..registerFactory<KeyValueStore>(
        () => NamespacedKeyValueStore(
          namespace: KeyNamespace(namespace: _namespace),
          inner:
              keyValueStore ??
              SharedPreferencesKeyValueStore(
                sharedPreferences: SharedPreferencesAsync(),
              ),
        ),
      )
      ..registerFactory<KeyValueDataSource>(
        () => DefaultKeyValueDataSource(store: _serviceLocator.get()),
      )
      ..registerFactory<ConfigManager>(() => DefaultConfigStore())
      ..unregister<ConfigRepository>()
      ..registerLazySingleton<ConfigRepository>(
        () => DefaultConfigRepository(
          dataSource: _serviceLocator.get(),
          manager: _serviceLocator.get(),
        )..populate(parameters.stringify()),
      );
  }

  Widget get entrypoint {
    return MultiProvider(
      providers: [Provider<ServiceLocator>(create: (_) => _serviceLocator)],
      child: const LocalConfigEntrypoint(),
    );
  }

  Stream<Map<String, dynamic>> get onConfigUpdated {
    final repo = _serviceLocator.get<ConfigRepository>();
    return repo.configsStream.map((configs) {
      return configs.map((key, config) => MapEntry(key, config.value));
    });
  }

  bool? getBool(String key) {
    final repo = _serviceLocator.get<ConfigRepository>();
    final config = repo.get(key);
    return config?.value.toBoolOrNull();
  }

  double? getDouble(String key) {
    final repo = _serviceLocator.get<ConfigRepository>();
    final config = repo.get(key);
    return config?.value.toStrictDoubleOrNull();
  }

  int? getInt(String key) {
    final repo = _serviceLocator.get<ConfigRepository>();
    final config = repo.get(key);
    return config?.value.toStrictIntOrNull();
  }

  String? getString(String key) {
    final repo = _serviceLocator.get<ConfigRepository>();
    final config = repo.get(key);
    return config?.value;
  }
}

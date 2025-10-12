library local_config;

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_config/data/store/config_store.dart';
import 'package:local_config/data/store/default_config_store.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_config/common/extension/string_extension.dart';
import 'package:local_config/core/di/service_locator.dart';
import 'package:local_config/core/service/key_value_service.dart';
import 'package:local_config/data/data_source/default_key_value_data_source.dart';
import 'package:local_config/data/repository/default_config_repository.dart';
import 'package:local_config/data/repository/no_op_config_repository.dart';
import 'package:local_config/data/data_source/key_value_data_source.dart';
import 'package:local_config/domain/repository/config_repository.dart';
import 'package:local_config/infra/di/get_it_service_locator.dart';
import 'package:local_config/infra/service/namespaced_key_value_service.dart';
import 'package:local_config/infra/service/secure_storage_key_value_service.dart';
import 'package:local_config/infra/service/shared_preferences_key_value_service.dart';
import 'package:local_config/common/util/key_namespace.dart';
import 'package:local_config/ui/local_config_entrypoint.dart';

class LocalConfig {
  static const _namespace = 'local_config';

  static final instance = LocalConfig._();

  final _serviceLocator = GetItServiceLocator();

  LocalConfig._() {
    _serviceLocator.registerLazySingleton<ConfigRepository>(
      () => NoOpConfigRepository(),
    );
  }

  void initialize({
    required Map<String, String> defaults,
    bool isSecureStorageEnabled = false,
  }) {
    _serviceLocator
      ..registerFactory<KeyValueService>(
        () => NamespacedKeyValueService(
          namespace: KeyNamespace(namespace: _namespace),
          inner: isSecureStorageEnabled
              ? SecureStorageKeyValueService(
                  secureStorage: const FlutterSecureStorage(
                    aOptions: AndroidOptions(
                      encryptedSharedPreferences: true,
                    ),
                  ),
                )
              : SharedPreferencesKeyValueService(
                  sharedPreferences: SharedPreferencesAsync(),
                ),
        ),
      )
      ..registerFactory<KeyValueDataSource>(
        () => DefaultKeyValueDataSource(
          service: _serviceLocator.get(),
        ),
      )
      ..registerFactory<ConfigStore>(
        () => DefaultConfigStore(),
      )
      ..unregister<ConfigRepository>()
      ..registerLazySingleton<ConfigRepository>(
        () => DefaultConfigRepository(
          dataSource: _serviceLocator.get(),
          store: _serviceLocator.get(),
        )..populate(defaults),
      );
  }

  Widget get entrypoint {
    return Provider<ServiceLocator>(
      create: (_) => _serviceLocator,
      child: const LocalConfigEntrypoint(),
    );
  }

  Stream<Map<String, String>> get onConfigUpdated {
    final repo = _serviceLocator.get<ConfigRepository>();
    return repo.configsStream.map((configs) {
      return configs.map((key, config) => MapEntry(key, config.value));
    });
  }

  bool? getBool(String key) {
    final repo = _serviceLocator.get<ConfigRepository>();
    final config = repo.get(key);
    return config?.value.asBoolOrNull;
  }

  double? getDouble(String key) {
    final repo = _serviceLocator.get<ConfigRepository>();
    final config = repo.get(key);
    return config?.value.asDoubleOrNull;
  }

  int? getInt(String key) {
    final repo = _serviceLocator.get<ConfigRepository>();
    final config = repo.get(key);
    return config?.value.asIntOrNull;
  }

  String? getString(String key) {
    final repo = _serviceLocator.get<ConfigRepository>();
    final config = repo.get(key);
    return config?.value;
  }
}

import 'package:local_config/src/domain/policy/baseline_value_prune_policy.dart';
import 'package:local_config/src/domain/policy/composite_prune_policy.dart';
import 'package:local_config/src/domain/policy/mismatch_qualified_prefix_prune_policy.dart';
import 'package:local_config/src/domain/policy/missing_retained_key_prune_policy.dart';
import 'package:local_config/src/infra/di/internal_service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_config/src/common/extension/map_extension.dart';
import 'package:local_config/src/core/model/key_namespace.dart';
import 'package:local_config/src/common/util/stringify.dart';
import 'package:local_config/src/core/storage/key_value_store.dart';
import 'package:local_config/src/data/data_source/default_key_value_data_source.dart';
import 'package:local_config/src/data/data_source/key_value_data_source.dart';
import 'package:local_config/src/domain/manager/config_manager.dart';
import 'package:local_config/src/domain/manager/default_config_manager.dart';
import 'package:local_config/src/data/repository/default_config_repository.dart';
import 'package:local_config/src/data/repository/no_op_config_repository.dart';
import 'package:local_config/src/domain/entity/config.dart';
import 'package:local_config/src/domain/repository/config_repository.dart';
import 'package:local_config/src/infra/storage/shared_preferences_key_value_store.dart';

final class LocalConfig {
  static const _namespace = 'local_config';

  static final instance = LocalConfig._();

  LocalConfig._() {
    serviceLocator.registerLazySingleton<ConfigRepository>(
      () => NoOpConfigRepository(),
    );
  }

  void initialize({
    required Map<String, Object> params,
    KeyValueStore? store,
    List<String> keySegments = const [],
  }) {
    serviceLocator
      ..registerFactory<KeyValueStore>(
        () =>
            store ??
            SharedPreferencesKeyValueStore(
              sharedPreferences: SharedPreferencesAsync(),
            ),
      )
      ..registerFactory<KeyValueDataSource>(
        () => DefaultKeyValueDataSource(
          namespace: KeyNamespace(base: _namespace, segments: keySegments),
          store: serviceLocator.get(),
          prunePolicy: CompositePrunePolicy(
            policies: [
              MismatchQualifiedPrefixPrunePolicy(),
              MissingRetainedKeyPrunePolicy(),
              BaselineValuePrunePolicy(),
            ],
          ),
        ),
      )
      ..registerFactory<ConfigManager>(() => DefaultConfigManager())
      ..unregister<ConfigRepository>()
      ..registerLazySingleton<ConfigRepository>(
        () => DefaultConfigRepository(
          dataSource: serviceLocator.get(),
          manager: serviceLocator.get(),
        )..populate(params.mapValues((Object value) => stringify(value))),
      );
  }

  Stream<Map<String, Object>> get onConfigUpdated {
    final repo = serviceLocator.get<ConfigRepository>();
    return repo.configsStream.map((configs) {
      return configs.map((key, config) => MapEntry(key, config.parsed));
    });
  }

  Map<String, Object> getAll() {
    final repo = serviceLocator.get<ConfigRepository>();
    return repo.configs.map((key, config) => MapEntry(key, config.parsed));
  }

  bool? getBool(String key) {
    final value = _getValue(key);
    if (value == null) return null;
    return bool.tryParse(value.raw);
  }

  double? getDouble(String key) {
    final value = _getValue(key);
    if (value == null) return null;
    return double.tryParse(value.raw);
  }

  int? getInt(String key) {
    final value = _getValue(key);
    if (value == null) return null;
    return int.tryParse(value.raw);
  }

  String? getString(String key) {
    final value = _getValue(key);
    if (value == null) return null;
    return value.raw;
  }

  Future<void> clear() async {
    final repo = serviceLocator.get<ConfigRepository>();
    await repo.clear();
  }

  ConfigValue? _getValue(String key) {
    final repo = serviceLocator.get<ConfigRepository>();
    return repo.get(key);
  }
}

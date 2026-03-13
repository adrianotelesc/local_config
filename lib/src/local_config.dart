import 'package:local_config/src/common/extensions/map_extension.dart';
import 'package:local_config/src/common/utils/type_converters.dart';
import 'package:local_config/src/domain/entity/local_config_settings.dart';
import 'package:local_config/src/domain/entity/local_config_update.dart';
import 'package:local_config/src/domain/entity/local_config_value.dart';
import 'package:local_config/src/domain/policy/baseline_value_prune_policy.dart';
import 'package:local_config/src/domain/policy/composite_prune_policy.dart';
import 'package:local_config/src/domain/policy/mismatch_qualified_prefix_prune_policy.dart';
import 'package:local_config/src/domain/policy/missing_retained_key_prune_policy.dart';
import 'package:local_config/src/domain/policy/prune_policy.dart';
import 'package:local_config/src/infra/di/internal_service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_config/src/core/model/key_namespace.dart';
import 'package:local_config/src/core/storage/key_value_store.dart';
import 'package:local_config/src/data/data_source/default_key_value_data_source.dart';
import 'package:local_config/src/data/data_source/key_value_data_source.dart';
import 'package:local_config/src/domain/manager/config_manager.dart';
import 'package:local_config/src/domain/manager/default_config_manager.dart';
import 'package:local_config/src/data/repository/default_config_repository.dart';
import 'package:local_config/src/domain/repository/config_repository.dart';
import 'package:local_config/src/infra/storage/shared_preferences_key_value_store.dart';

final class LocalConfig {
  static const _keyNamespace = 'local_config';

  static final instance = LocalConfig._();

  LocalConfig._() {
    serviceLocator
      ..registerFactory<KeyValueStore>(
        () => SharedPreferencesKeyValueStore(
          sharedPreferences: SharedPreferencesAsync(),
        ),
      )
      ..registerFactory<KeyValuePrunePolicy>(
        () => CompositePrunePolicy(
          policies: [
            MismatchQualifiedPrefixPrunePolicy(),
            MissingRetainedKeyPrunePolicy(),
            BaselineValuePrunePolicy(),
          ],
        ),
      )
      ..registerFactory<KeyValueDataSource>(
        () => DefaultKeyValueDataSource(
          namespace: KeyNamespace(base: _keyNamespace),
          store: serviceLocator.get(),
          prunePolicy: serviceLocator.get(),
        ),
      )
      ..registerFactory<ConfigManager>(() => DefaultConfigManager())
      ..registerLazySingleton<ConfigRepository>(
        () => DefaultConfigRepository(
          dataSource: serviceLocator.get(),
          manager: serviceLocator.get(),
        ),
      );
  }

  void setConfigSettings(LocalConfigSettings settings) {
    final keyStoreValue = settings.keyValueStore;
    if (keyStoreValue != null) {
      serviceLocator
        ..unregister<KeyValueStore>()
        ..registerFactory<KeyValueStore>(() => keyStoreValue);
    }

    final keySegments = settings.keySegments;
    if (keySegments.isNotEmpty) {
      serviceLocator
        ..unregister<KeyValueDataSource>()
        ..registerFactory<KeyValueDataSource>(
          () => DefaultKeyValueDataSource(
            namespace: KeyNamespace(base: _keyNamespace, segments: keySegments),
            store: serviceLocator.get(),
            prunePolicy: serviceLocator.get(),
          ),
        );
    }
  }

  Future<void> setDefaults(Map<String, Object> defaults) async {
    final repo = serviceLocator.get<ConfigRepository>();
    await repo.populate(defaults.mapValues((Object value) => stringify(value)));
  }

  Stream<LocalConfigUpdate> get onConfigUpdated {
    final repo = serviceLocator.get<ConfigRepository>();
    return repo.onConfigUpdated;
  }

  Map<String, Object> getAll() {
    final repo = serviceLocator.get<ConfigRepository>();
    return repo.values.map((key, config) => MapEntry(key, config.parsed));
  }

  bool? getBool(String key) {
    final value = getValue(key);
    if (value == null) return null;
    return tryParseBool(value.raw);
  }

  double? getDouble(String key) {
    final value = getValue(key);
    if (value == null) return null;
    return double.tryParse(value.raw);
  }

  int? getInt(String key) {
    final value = getValue(key);
    if (value == null) return null;
    return int.tryParse(value.raw);
  }

  String? getString(String key) {
    final value = getValue(key);
    if (value == null) return null;
    return value.raw;
  }

  Future<void> clear() async {
    final repo = serviceLocator.get<ConfigRepository>();
    await repo.clear();
  }

  LocalConfigValue? getValue(String key) {
    final repo = serviceLocator.get<ConfigRepository>();
    return repo.get(key);
  }
}

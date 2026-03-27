import 'package:local_config/src/common/utils/type_converters.dart';
import 'package:local_config/src/data/repositories/local_config_repository_impl.dart';
import 'package:local_config/src/domain/entities/local_config_update.dart';
import 'package:local_config/src/domain/entities/local_config_value.dart';
import 'package:local_config/src/domain/repositories/local_config_repository.dart';
import 'package:local_config/src/infra/models/key_namespace.dart';
import 'package:local_config/src/infra/models/local_config_settings.dart';
import 'package:local_config/src/infra/persistence/scoped_key_value_storage.dart';
import 'package:local_config/src/local_config_internals.dart';

/// The entry point for accessing Local Config.
final class LocalConfig {
  static const _keyNamespaceBase = 'local_config';

  /// Returns the singleton instance of LocalConfig.
  static final instance = LocalConfig._();

  LocalConfig._();

  var _initialized = false;
  bool get initialized => _initialized;

  /// Returns a Map of all Local Config parameters.
  Map<String, LocalConfigValue> get all =>
      _repo.configs.map((key, value) => MapEntry(key, value));

  LocalConfigRepository get _repo {
    return configRepository;
  }

  Stream<LocalConfigUpdate> get onConfigUpdated => _repo.onConfigUpdated;

  /// Initializes the LocalConfig with the provided settings.
  /// This method must be called before accessing any other methods.
  Future<void> initialize({
    required final LocalConfigSettings configSettings,
  }) async {
    configRepository = LocalConfigRepositoryImpl(
      storage: ScopedKeyValueStorage(
        namespace: KeyNamespace(
          base: _keyNamespaceBase,
          segments: configSettings.keyNamespaceSegments,
        ),
        delegate: configSettings.keyValueStorage,
      ),
    );

    _initialized = true;
  }

  /// Sets the default parameter values.
  Future<void> setDefaults(final Map<String, Object> defaults) =>
      _repo.setDefaults(
        defaults.map((key, value) => MapEntry(key, stringify(value))),
      );

  /// Gets the value for a given key as a bool.
  bool? getBool(final String key) => getValue(key)?.asBool;

  /// Gets the LocalConfigValue for a given key.
  LocalConfigValue? getValue(final String key) => _repo.get(key);

  /// Gets the value for a given key as a double.
  double? getDouble(final String key) => getValue(key)?.asDouble;

  ///  Gets the value for a given key as an int.
  int? getInt(final String key) => getValue(key)?.asInt;

  /// Gets the value for a given key as a String.
  String? getString(final String key) => getValue(key)?.asString;

  /// Resets all parameters to the default values.
  Future<void> resetAll() => _repo.resetAll();
}

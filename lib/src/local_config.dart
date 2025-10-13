part of '../local_config.dart';

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
          inner:
              isSecureStorageEnabled
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

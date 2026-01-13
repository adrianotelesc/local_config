part of '../local_config.dart';

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
    final stringfiedParameters = parameters.map((key, value) {
      return MapEntry(key, value?.toString() ?? '');
    });
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
        )..populate(stringfiedParameters),
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

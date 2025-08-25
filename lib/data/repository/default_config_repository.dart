import 'dart:async';

import 'package:local_config/domain/model/config.dart';
import 'package:local_config/domain/repository/config_repository.dart';
import 'package:local_config/domain/data_source/key_value_data_source.dart';

class DefaultConfigRepository implements ConfigRepository {
  final KeyValueDataSource _store;

  final _configs = <String, Config>{};

  final _configsController = StreamController<Map<String, Config>>.broadcast();

  DefaultConfigRepository({
    required KeyValueDataSource store,
  }) : _store = store;

  @override
  Map<String, Config> get configs => Map.unmodifiable(_configs);

  @override
  Stream<Map<String, Config>> get configsStream => _configsController.stream;

  @override
  Future<void> populate(Map<String, String> configs) async {
    _populate(configs);
    await _store.prune(configs.keys.toSet());
  }

  Future<void> _populate(Map<String, String> all) async {
    final stored = await _store.all;
    _configs.addAll(
      all.map((key, value) {
        return MapEntry(
          key,
          Config(
            defaultValue: value,
            overriddenValue: stored[key],
          ),
        );
      }),
    );
    _configsController.add(configs);
  }

  @override
  Future<Config?> get(String key) async => _configs[key];

  @override
  Future<void> set(String key, String value) async {
    final updated = _update(key, value);

    if (!updated.isOverridden) {
      await _store.remove(key);
    } else {
      await _store.set(key, value);
    }
  }

  Config _update(String key, String? value) {
    final updated = _configs.update(key, (config) {
      return config.copyWith(overriddenValue: value);
    });
    _configsController.add(configs);
    return updated;
  }

  @override
  Future<void> reset(String key) async {
    _update(key, null);
    await _store.remove(key);
  }

  @override
  Future<void> resetAll() async {
    _updateAll();
    await _store.clear();
  }

  void _updateAll() {
    _configs.updateAll((_, value) {
      return value.copyWith(overriddenValue: null);
    });
    _configsController.add(configs);
  }
}

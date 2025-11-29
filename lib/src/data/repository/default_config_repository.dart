import 'dart:async';

import 'package:local_config/src/data/data_source/key_value_data_source.dart';
import 'package:local_config/src/data/store/config_store.dart';
import 'package:local_config/src/domain/entity/config.dart';
import 'package:local_config/src/domain/repository/config_repository.dart';

class DefaultConfigRepository implements ConfigRepository {
  final KeyValueDataSource _dataSource;

  final ConfigStore _store;

  final _controller =
      StreamController<Map<String, LocalConfigValue>>.broadcast();

  DefaultConfigRepository({
    required KeyValueDataSource dataSource,
    required ConfigStore store,
  }) : _dataSource = dataSource,
       _store = store;

  @override
  Map<String, LocalConfigValue> get configs => _store.configs;

  @override
  Stream<Map<String, LocalConfigValue>> get configsStream => _controller.stream;

  @override
  LocalConfigValue? get(String key) => _store.get(key);

  @override
  Future<void> populate(Map<String, dynamic> defaults) async {
    final overrides = await _dataSource.all;

    _store.populate(defaults, overrides);

    await _dataSource.prune(defaults.keys.toSet());

    _controller.add(configs);
  }

  @override
  Future<void> reset(String key) async {
    _store.update(key, null);

    await _dataSource.remove(key);

    _controller.add(configs);
  }

  @override
  Future<void> resetAll() async {
    _store.updateAll(null);

    await _dataSource.clear();

    _controller.add(configs);
  }

  @override
  Future<void> set(String key, dynamic value) async {
    final updated = _store.update(key, value);

    if (!updated.isOverridden) {
      await _dataSource.remove(key);
    } else {
      await _dataSource.set(key, value);
    }

    _controller.add(configs);
  }
}

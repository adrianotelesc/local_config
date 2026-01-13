import 'dart:async';

import 'package:local_config/src/data/data_source/key_value_data_source.dart';
import 'package:local_config/src/data/manager/config_manager.dart';
import 'package:local_config/src/domain/entity/config.dart';
import 'package:local_config/src/domain/repository/config_repository.dart';

class DefaultConfigRepository implements ConfigRepository {
  final KeyValueDataSource _dataSource;

  final ConfigManager _manager;

  final _controller = StreamController<Map<String, ConfigValue>>.broadcast();

  DefaultConfigRepository({
    required KeyValueDataSource dataSource,
    required ConfigManager manager,
  }) : _dataSource = dataSource,
       _manager = manager;

  @override
  Map<String, ConfigValue> get configs => _manager.configs;

  @override
  Stream<Map<String, ConfigValue>> get configsStream => _controller.stream;

  @override
  ConfigValue? get(String key) => _manager.get(key);

  @override
  Future<void> populate(Map<String, String> defaults) async {
    final overrides = await _dataSource.all;

    _manager.populate(defaults, overrides);

    await _dataSource.prune(defaults.keys.toSet());

    _controller.add(configs);
  }

  @override
  Future<void> reset(String key) async {
    _manager.update(key, null);

    await _dataSource.remove(key);

    _controller.add(configs);
  }

  @override
  Future<void> resetAll() async {
    _manager.updateAll(null);

    await _dataSource.clear();

    _controller.add(configs);
  }

  @override
  Future<void> set(String key, String value) async {
    final updated = _manager.update(key, value);

    if (!updated.isOverridden) {
      await _dataSource.remove(key);
    } else {
      await _dataSource.set(key, value);
    }

    _controller.add(configs);
  }
}

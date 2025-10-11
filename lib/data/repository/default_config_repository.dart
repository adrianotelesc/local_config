import 'dart:async';

import 'package:local_config/domain/data_source/key_value_data_source.dart';
import 'package:local_config/domain/model/config.dart';
import 'package:local_config/domain/repository/config_repository.dart';

class DefaultConfigRepository implements ConfigRepository {
  final KeyValueDataSource _dataSource;

  final _configs = <String, Config>{};

  final _controller = StreamController<Map<String, Config>>.broadcast();

  DefaultConfigRepository({
    required KeyValueDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Map<String, Config> get configs => Map.unmodifiable(_configs);

  @override
  Stream<Map<String, Config>> get configsStream => _controller.stream;

  @override
  Config? get(String key) => _configs[key];

  @override
  Future<void> populate(Map<String, String> configs) async {
    _populate(configs);
    await _dataSource.prune(configs.keys.toSet());
  }

  @override
  Future<void> reset(String key) async {
    _update(key, null);
    await _dataSource.remove(key);
  }

  @override
  Future<void> resetAll() async {
    _updateAll();
    await _dataSource.clear();
  }

  @override
  Future<void> set(String key, String value) async {
    final updated = _update(key, value);

    if (!updated.isOverridden) {
      await _dataSource.remove(key);
    } else {
      await _dataSource.set(key, value);
    }
  }

  Future<void> _populate(Map<String, String> all) async {
    final allStored = await _dataSource.all;
    _configs.addAll(
      all.map((key, value) {
        return MapEntry(
          key,
          Config(
            defaultValue: value,
            overriddenValue: allStored[key],
          ),
        );
      }),
    );
    _controller.add(configs);
  }

  Config _update(String key, String? value) {
    final updated = _configs.update(key, (config) {
      return config.copyWith(overriddenValue: value);
    });
    _controller.add(configs);
    return updated;
  }

  void _updateAll() {
    _configs.updateAll((_, value) {
      return value.copyWith(overriddenValue: null);
    });
    _controller.add(configs);
  }
}

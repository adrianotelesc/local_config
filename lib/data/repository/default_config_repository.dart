import 'dart:async';

import 'package:local_config/domain/model/config.dart';
import 'package:local_config/domain/repository/config_repository.dart';
import 'package:local_config/domain/data_source/key_value_data_source.dart';

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
  Future<void> populate(Map<String, String> configs) async {
    _populate(configs);
    await _dataSource.prune(configs.keys.toSet());
  }

  Future<void> _populate(Map<String, String> all) async {
    final stored = await _dataSource.all;
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
    _controller.add(configs);
  }

  @override
  Future<Config?> get(String key) async => _configs[key];

  @override
  Future<void> set(String key, String value) async {
    final updated = _update(key, value);

    if (!updated.isOverridden) {
      await _dataSource.remove(key);
    } else {
      await _dataSource.set(key, value);
    }
  }

  Config _update(String key, String? value) {
    final updated = _configs.update(key, (config) {
      return config.copyWith(overriddenValue: value);
    });
    _controller.add(configs);
    return updated;
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

  void _updateAll() {
    _configs.updateAll((_, value) {
      return value.copyWith(overriddenValue: null);
    });
    _controller.add(configs);
  }
}

import 'dart:async';

import 'package:local_config/src/data/data_source/key_value_data_source.dart';
import 'package:local_config/src/domain/entity/local_config_update.dart';
import 'package:local_config/src/domain/entity/local_config_value.dart';
import 'package:local_config/src/domain/manager/config_manager.dart';
import 'package:local_config/src/domain/repository/config_repository.dart';

class DefaultConfigRepository implements ConfigRepository {
  final KeyValueDataSource _dataSource;

  final ConfigManager _manager;

  final _controller = StreamController<LocalConfigUpdate>.broadcast();

  DefaultConfigRepository({
    required KeyValueDataSource dataSource,
    required ConfigManager manager,
  }) : _dataSource = dataSource,
       _manager = manager;

  @override
  Map<String, LocalConfigValue> get values => _manager.configs;

  @override
  Stream<LocalConfigUpdate> get onConfigUpdated => _controller.stream;

  @override
  LocalConfigValue? get(String key) => _manager.get(key);

  @override
  Future<void> populate(Map<String, String> defaultParameters) async {
    final retainedKeys = defaultParameters.keys.toSet();

    await _dataSource.prune(retainedKeys);

    final overrideParameters = await _dataSource.all;

    for (final key in retainedKeys) {
      if (defaultParameters[key] == overrideParameters[key]) {
        overrideParameters.remove(key);
        _dataSource.remove(key);
      }
    }

    _manager.populate(defaultParameters, overrideParameters);
  }

  @override
  Future<void> remove(String key) async {
    _manager.update(key, null);

    await _dataSource.remove(key);

    _controller.add(LocalConfigUpdate({key}));
  }

  @override
  Future<void> clear() async {
    _manager.updateAll(null);

    final all = await _dataSource.all;
    await _dataSource.clear();

    _controller.add(LocalConfigUpdate({...all.keys}));
  }

  @override
  Future<void> set(String key, String value) async {
    final updated = _manager.update(key, value);

    if (!updated.isOverridden) {
      await _dataSource.remove(key);
    } else {
      await _dataSource.set(key, value);
    }

    _controller.add(LocalConfigUpdate({key}));
  }
}

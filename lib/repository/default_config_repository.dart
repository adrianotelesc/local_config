import 'dart:async';

import 'package:local_config/model/config.dart';
import 'package:local_config/repository/config_repository.dart';
import 'package:local_config/storage/key_value_store.dart';

class DefaultConfigRepository implements ConfigRepository {
  final KeyValueStore _store;

  var _populateStatus = PopulateStatus.notStarted;

  final _populateStatusController =
      StreamController<PopulateStatus>.broadcast();

  final _configs = <String, Config>{};

  final _configsController = StreamController<Map<String, Config>>.broadcast();

  DefaultConfigRepository({
    required KeyValueStore store,
  }) : _store = store;

  @override
  PopulateStatus get populateStatus => _populateStatus;

  @override
  Stream<PopulateStatus> get populateStatusStream =>
      _populateStatusController.stream;

  @override
  Map<String, Config> get configs => Map.unmodifiable(_configs);

  @override
  Stream<Map<String, Config>> get configsStream => _configsController.stream;

  @override
  Future<void> populate({
    required Map<String, String> all,
  }) async {
    _populateStatus = PopulateStatus.inProgress;
    _populateStatusController.add(_populateStatus);
    final stored = await _store.all;
    _populateConfigs(all, stored);
    await _pruneStore(all, stored);
    _populateStatus = PopulateStatus.completed;
    _populateStatusController.add(_populateStatus);
  }

  void _populateConfigs(
    Map<String, String> all,
    Map<String, String> stored,
  ) {
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

  Future<void> _pruneStore(
    Map<String, String> all,
    Map<String, String> stored,
  ) async {
    final keysToRemove = stored.keys.where((key) {
      return !all.containsKey(key);
    });
    await Future.wait(keysToRemove.map(_store.remove));
  }

  @override
  Future<Config?> get(String key) async => _configs[key];

  @override
  Future<void> set(String key, String value) async {
    final changed = _changeConfig(key, value);
    if (!changed) return;

    await _store.set(key, value);
  }

  bool _changeConfig(String key, String? value) {
    if (!_configs.containsKey(key)) return false;

    _configs.update(key, (config) => config.copyWith(value));
    _configsController.add(configs);
    return true;
  }

  @override
  Future<void> reset(String key) async {
    final changed = _changeConfig(key, null);
    if (!changed) return;

    await _store.remove(key);
  }

  @override
  Future<void> resetAll() async {
    _configs.updateAll((key, value) => value.copyWith(null));
    _configsController.add(configs);

    await _store.clear();
  }
}

import 'dart:async';

import 'package:local_config/src/common/extensions/map_extension.dart';
import 'package:local_config/src/core/persistence/key_value_storage.dart';
import 'package:local_config/src/domain/entities/local_config_update.dart';
import 'package:local_config/src/domain/entities/local_config_value.dart';
import 'package:local_config/src/domain/repositories/local_config_repository.dart';

class LocalConfigRepositoryImpl implements LocalConfigRepository {
  LocalConfigRepositoryImpl({required KeyValueStorage storage})
    : _storage = storage;

  final KeyValueStorage _storage;

  @override
  Map<String, LocalConfigValue> get configs => _configs;
  var _configs = <String, LocalConfigValue>{};

  @override
  Stream<LocalConfigUpdate> get onConfigUpdated => _controller.stream;
  final _controller = StreamController<LocalConfigUpdate>.broadcast();

  @override
  Future<void> setDefaults(Map<String, String> defaults) async {
    final overrides = await _storage.all;

    final retainedOverrides = defaults.where((key, value) {
      final overrideValue = overrides[key];
      return overrideValue != null && overrideValue != value;
    });

    await _storage.prune(retainedOverrides.keys.toSet());

    _configs = defaults.map((key, value) {
      return MapEntry(
        key,
        LocalConfigValue(
          type: LocalConfigType.infer(value),
          defaultValue: value,
          overrideValue: retainedOverrides[key],
        ),
      );
    });
  }

  @override
  LocalConfigValue? get(String key) => _configs[key];

  @override
  Future<void> set(String key, String value) async {
    final updated = _configs.update(key, (configValue) {
      return configValue.withOverride(value);
    });

    if (updated.hasOverride) {
      await _storage.setString(key, value);
    } else {
      await _storage.remove(key);
    }

    _controller.add(LocalConfigUpdate({key}));
  }

  @override
  Future<void> reset(String key) async {
    _configs.update(key, (configValue) {
      return configValue.withOverride(null);
    });

    await _storage.remove(key);

    _controller.add(LocalConfigUpdate({key}));
  }

  @override
  Future<void> resetAll() async {
    _configs.updateAll((_, configValue) {
      return configValue.withOverride(null);
    });

    await _storage.clear();

    _controller.add(LocalConfigUpdate({..._configs.keys}));
  }
}

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:local_config/local_config.dart';
import 'package:local_config/src/domain/entities/local_config_update.dart';
import 'package:local_config/src/domain/repositories/local_config_repository.dart';

class FakeLocalConfigRepositoryImpl implements LocalConfigRepository {
  final _controller = StreamController<LocalConfigUpdate>.broadcast();

  @override
  Map<String, LocalConfigValue> get all => {};

  @override
  Map<String, String> get defaults => UnmodifiableMapView(_defaults);
  final Map<String, String> _defaults = {};

  @override
  Map<String, String> get locals => UnmodifiableMapView(_locals);
  final Map<String, String> _locals = {};

  @override
  Stream<LocalConfigUpdate> get onConfigUpdated => _controller.stream;

  @override
  LocalConfigValue? getValue(String key) {
    final defaultValue = _defaults[key];
    if (defaultValue == null) return null;

    final localValue = _locals[key];

    return LocalConfigValue(
      value: localValue ?? defaultValue,
      source:
          localValue != null && localValue != defaultValue
              ? ValueSource.valueLocal
              : ValueSource.valueDefault,
    );
  }

  @override
  Future<void> set(String key, String value) async {
    _locals[key] = value;
    _controller.add(LocalConfigUpdate({key}));
  }

  @override
  Future<void> reset(String key) async {
    _locals.remove(key);
    _controller.add(LocalConfigUpdate({key}));
  }

  @override
  Future<void> resetAll() async {
    final updatedKeys = _locals.keys;
    _locals.clear();
    _controller.add(LocalConfigUpdate(updatedKeys.toSet()));
  }

  @override
  Future<void> setDefaults(Map<String, String> defaults) async {
    _defaults
      ..clear()
      ..addAll(defaults);
  }
}

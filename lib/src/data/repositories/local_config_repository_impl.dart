import 'dart:async';

import 'package:local_config/src/common/extensions/map_extension.dart';
import 'package:local_config/src/common/utils/type_converters.dart';
import 'package:local_config/src/core/persistence/key_value_storage.dart';
import 'package:local_config/src/domain/entities/local_config_update.dart';
import 'package:local_config/src/domain/entities/local_config_value.dart';
import 'package:local_config/src/domain/repositories/local_config_repository.dart';

class LocalConfigRepositoryImpl implements LocalConfigRepository {
  LocalConfigRepositoryImpl({required KeyValueStorage storage})
    : _storage = storage;

  final KeyValueStorage _storage;

  @override
  Map<String, LocalConfigValue> get all {
    Map<String, LocalConfigValue> all = {};

    for (final key in _defaults.keys) {
      final value = getValue(key);
      if (value == null) continue;

      all[key] = value;
    }

    return all;
  }

  @override
  Map<String, String> get defaults => _defaults;
  var _defaults = <String, String>{};

  @override
  Map<String, String> get locals => _locals;
  var _locals = <String, String>{};

  @override
  Stream<LocalConfigUpdate> get onConfigUpdated => _controller.stream;
  final _controller = StreamController<LocalConfigUpdate>.broadcast();

  @override
  Future<void> setDefaults(Map<String, String> defaults) async {
    _defaults = defaults;
    final locals = await _storage.all;

    final retainedLocals = locals.where((key, value) {
      final defaultValue = defaults[key];
      if (defaultValue == null) return false;

      return defaultValue != value &&
          parseValue(defaultValue).runtimeType == parseValue(value).runtimeType;
    });

    await _storage.prune(retainedLocals.keys.toSet());

    _locals = retainedLocals;
  }

  @override
  LocalConfigValue? getValue(String key) {
    final defaultValue = _defaults[key];
    if (defaultValue == null) return null;

    final localValue = _locals[key];
    if (localValue != null && localValue != defaultValue) {
      return LocalConfigValue(
        value: localValue,
        source: ValueSource.valueLocal,
      );
    }

    return LocalConfigValue(
      value: defaultValue,
      source: ValueSource.valueDefault,
    );
  }

  @override
  Future<void> set(String key, String value) async {
    final defaultValue = _defaults[key];
    if (defaultValue == null) return;

    if (value != defaultValue) {
      _locals[key] = value;
      await _storage.setString(key, value);
    } else {
      _locals.remove(key);
      await _storage.remove(key);
    }

    _controller.add(LocalConfigUpdate({key}));
  }

  @override
  Future<void> reset(String key) async {
    _locals.remove(key);
    await _storage.remove(key);

    _controller.add(LocalConfigUpdate({key}));
  }

  @override
  Future<void> resetAll() async {
    final updatedKeys = _locals.keys.toSet();
    _locals.clear();
    await _storage.clear();

    _controller.add(LocalConfigUpdate(updatedKeys));
  }
}

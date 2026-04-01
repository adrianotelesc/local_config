import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:local_config/src/common/extensions/string_extension.dart';
import 'package:local_config/src/domain/entities/local_config_update.dart';
import 'package:local_config/src/domain/repositories/local_config_repository.dart';
import 'package:local_config/src/presentation/models/config_value.dart';

class ConfigNotifier extends ChangeNotifier {
  ConfigNotifier({
    required LocalConfigRepository configRepo,
  }) : _configRepo = configRepo {
    _load();
    _configUpdateSub = _configRepo.onConfigUpdated.listen(_update);
  }

  final LocalConfigRepository _configRepo;

  StreamSubscription? _configUpdateSub;

  var _all = <String, ConfigValue>{};
  Map<String, ConfigValue> get all => UnmodifiableMapView(_all);

  var _filtered = <MapEntry<String, ConfigValue>>[];
  List<MapEntry<String, ConfigValue>> get filtered => _filtered;

  var _showOnlyLocals = false;
  bool get showOnlyLocals => _showOnlyLocals;
  set showOnlyLocals(bool value) {
    if (value == _showOnlyLocals) return;
    _showOnlyLocals = value;
    _applyFilters();
    notifyListeners();
  }

  bool get hasLocalValue => _all.values.any((config) => config.hasLocalValue);

  var _terms = <String>{};
  Set<String> get terms => UnmodifiableSetView(_terms);

  @override
  void dispose() {
    _configUpdateSub?.cancel();
    _configUpdateSub = null;
    super.dispose();
  }

  void query(String query) {
    _terms = query.split(RegExp(r'\W+')).toSet();
    _applyFilters(query: query);
    notifyListeners();
  }

  void _update(LocalConfigUpdate configUpdate) {
    for (final key in configUpdate.updatedKeys) {
      _all.update(key, (configValue) {
        return configValue.copyWith(overrideValue: _configRepo.locals[key]);
      });
    }
    _applyFilters();
    notifyListeners();
  }

  void _load() {
    _all = _configRepo.defaults.map((key, value) {
      return MapEntry(
        key,
        ConfigValue(
          type: ConfigValueType.fromValue(value),
          defaultValue: value,
          localValue: _configRepo.locals[key],
        ),
      );
    });
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters({String? query}) {
    _filtered =
        _all.entries
            .where((entry) => _overrideFilter(entry) && _termFilter(entry))
            .toList();
  }

  bool _overrideFilter(MapEntry<String, ConfigValue> entry) =>
      !_showOnlyLocals || entry.value.hasLocalValue;

  bool _termFilter(MapEntry<String, ConfigValue> entry) =>
      _terms.isEmpty ||
      _terms.every((term) {
        return "${entry.key} ${entry.value.defaultValue} ${entry.value.localValue}"
            .containsInsensitive(term);
      });

  Future<void> reset(String key) => _configRepo.reset(key);

  Future<void> resetAll() => _configRepo.resetAll();
}

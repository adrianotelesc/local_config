import 'package:flutter/material.dart';
import 'package:local_config/src/domain/repositories/local_config_repository.dart';
import 'package:local_config/src/presentation/models/config_value.dart';

class ConfigEditingNotifier extends ChangeNotifier {
  ConfigEditingNotifier({
    required LocalConfigRepository configRepo,
  }) : _configRepo = configRepo;

  final LocalConfigRepository _configRepo;

  late final String name;

  late final ConfigValue _configValue;
  ConfigValue get configValue => _configValue;

  String? _initialEditingLocalValue;
  String? get initialEditingLocalValue => _initialEditingLocalValue;

  var _showEditingLocalValue = false;
  bool get showEditingLocalValue => _showEditingLocalValue;
  set showEditingLocalValue(bool value) {
    if (value == _showEditingLocalValue) return;
    _showEditingLocalValue = value;
    notifyListeners();
  }

  var _shouldResetToDefault = false;
  bool get shouldResetToDefault => _shouldResetToDefault;
  set shouldResetToDefault(bool value) {
    if (value == _shouldResetToDefault) return;
    _shouldResetToDefault = value;
    notifyListeners();
  }

  void load(String name) {
    this.name = name;

    final defaultValue = _configRepo.defaults[name];
    if (defaultValue == null) return;

    final localValue = _configRepo.locals[name];

    _configValue = ConfigValue(
      type: ConfigValueType.fromValue(defaultValue),
      defaultValue: defaultValue,
      localValue: localValue,
    );

    _showEditingLocalValue = localValue != null;

    _initialEditingLocalValue = _configValue.effectiveValue;

    notifyListeners();
  }

  void save(final String editingLocalValue) {
    if (_shouldResetToDefault) {
      _configRepo.reset(name);
    } else {
      _configRepo.set(
        name,
        editingLocalValue,
      );
    }

    _shouldResetToDefault = false;
    notifyListeners();
  }
}

import 'package:local_config/src/data/manager/config_manager.dart';
import 'package:local_config/src/domain/entity/config.dart';

class DefaultConfigStore implements ConfigManager {
  final Map<String, ConfigValue> _configs = {};

  @override
  Map<String, ConfigValue> get configs =>
      Map<String, ConfigValue>.unmodifiable(_configs);

  @override
  ConfigValue? get(String key) => _configs[key];

  @override
  ConfigValue update(String key, dynamic value) {
    final updated = _configs.update(key, (config) {
      return config.copyWith(overriddenValue: value);
    });
    return updated;
  }

  @override
  void updateAll(dynamic value) {
    _configs.updateAll((_, value) {
      return value.copyWith(overriddenValue: null);
    });
  }

  @override
  void populate(Map<String, dynamic> defaults, Map<String, dynamic> overrides) {
    _configs.addAll(
      defaults.map((key, value) {
        return MapEntry(
          key,
          ConfigValue(defaultValue: value, overriddenValue: overrides[key]),
        );
      }),
    );
  }
}

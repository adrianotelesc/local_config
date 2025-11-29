import 'package:local_config/src/data/store/config_store.dart';
import 'package:local_config/src/domain/entity/config.dart';

class DefaultConfigStore implements ConfigStore {
  final Map<String, LocalConfigValue> _configs = {};

  @override
  Map<String, LocalConfigValue> get configs =>
      Map<String, LocalConfigValue>.unmodifiable(_configs);

  @override
  LocalConfigValue? get(String key) => _configs[key];

  @override
  LocalConfigValue update(String key, dynamic value) {
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
          LocalConfigValue(
            defaultValue: value,
            overriddenValue: overrides[key],
          ),
        );
      }),
    );
  }
}

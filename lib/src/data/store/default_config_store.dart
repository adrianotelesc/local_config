import 'package:local_config/src/data/store/config_store.dart';
import 'package:local_config/src/domain/entity/config.dart';

class DefaultConfigStore implements ConfigStore {
  final Map<String, Config> _configs = {};

  @override
  Map<String, Config> get configs => Map<String, Config>.unmodifiable(_configs);

  @override
  Config? get(String key) => _configs[key];

  @override
  Config update(String key, String? value) {
    final updated = _configs.update(key, (config) {
      return config.copyWith(overriddenValue: value);
    });
    return updated;
  }

  @override
  void updateAll(String? value) {
    _configs.updateAll((_, value) {
      return value.copyWith(overriddenValue: null);
    });
  }

  @override
  void populate(Map<String, String> defaults, Map<String, String> overrides) {
    _configs.addAll(
      defaults.map((key, value) {
        return MapEntry(
          key,
          Config(
            defaultValue: value,
            overriddenValue: overrides[key],
          ),
        );
      }),
    );
  }
}

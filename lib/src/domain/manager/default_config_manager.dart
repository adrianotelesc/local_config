import 'package:local_config/src/common/utils/case_validators.dart';
import 'package:local_config/src/domain/entity/local_config_value.dart';
import 'package:local_config/src/domain/manager/config_manager.dart';

class DefaultConfigManager implements ConfigManager {
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
  void populate(
    Map<String, dynamic> defaultParameters,
    Map<String, dynamic> overrideParameters,
  ) {
    _configs.addAll(
      defaultParameters.map((key, value) {
        return MapEntry(
          key,
          LocalConfigValue(
            defaultValue: value,
            overriddenValue: overrideParameters[key],
          ),
        );
      }),
    );
  }
}

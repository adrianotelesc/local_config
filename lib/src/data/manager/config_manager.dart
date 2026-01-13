import 'package:local_config/src/domain/entity/config.dart';

abstract class ConfigManager {
  Map<String, ConfigValue> get configs;

  void populate(Map<String, dynamic> defaults, Map<String, dynamic> overrides);

  ConfigValue? get(String key);

  ConfigValue update(String key, dynamic value);

  void updateAll(dynamic value);
}

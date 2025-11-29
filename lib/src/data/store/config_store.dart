import 'package:local_config/src/domain/entity/config.dart';

abstract class ConfigStore {
  Map<String, LocalConfigValue> get configs;

  void populate(Map<String, dynamic> defaults, Map<String, dynamic> overrides);

  LocalConfigValue? get(String key);

  LocalConfigValue update(String key, dynamic value);

  void updateAll(dynamic value);
}

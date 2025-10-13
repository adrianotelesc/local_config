import 'package:local_config/src/domain/entity/config.dart';

abstract class ConfigStore {
  Map<String, Config> get configs;

  void populate(Map<String, String> defaults, Map<String, String> overrides);

  Config? get(String key);

  Config update(String key, String? value);

  void updateAll(String? value);
}

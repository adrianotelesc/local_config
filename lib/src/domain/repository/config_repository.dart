import 'package:local_config/src/domain/entity/config.dart';

abstract class ConfigRepository {
  Map<String, LocalConfigValue> get configs;

  Stream<Map<String, LocalConfigValue>> get configsStream;

  LocalConfigValue? get(String key);

  Future<void> populate(Map<String, dynamic> defaults);

  Future<void> reset(String key);

  Future<void> resetAll();

  Future<void> set(String key, dynamic value);
}

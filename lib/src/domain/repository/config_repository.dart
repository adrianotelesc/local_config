import 'package:local_config/src/domain/entity/config.dart';

abstract class ConfigRepository {
  Map<String, Config> get configs;

  Stream<Map<String, Config>> get configsStream;

  Config? get(String key);

  Future<void> populate(Map<String, String> defaults);

  Future<void> reset(String key);

  Future<void> resetAll();

  Future<void> set(String key, String value);
}

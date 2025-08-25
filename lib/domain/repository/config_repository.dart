import 'package:local_config/domain/model/config.dart';

abstract class ConfigRepository {
  Map<String, Config> get configs;

  Stream<Map<String, Config>> get configsStream;

  Future<void> populate(Map<String, String> configs);

  Future<Config?> get(String key);

  Future<void> set(String key, String value);

  Future<void> reset(String key);

  Future<void> resetAll();
}

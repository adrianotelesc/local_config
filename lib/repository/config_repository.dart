import 'package:local_config/model/config.dart';

abstract class ConfigRepository {
  PopulateStatus get populateStatus;

  Stream<PopulateStatus> get populateStatusStream;

  Map<String, Config> get configs;

  Stream<Map<String, Config>> get configsStream;

  Future<void> populate({
    required Map<String, String> all,
  });

  Future<Config?> get(String key);

  Future<void> set(String key, String value);

  Future<void> reset(String key);

  Future<void> resetAll();
}

enum PopulateStatus {
  notStarted,
  inProgress,
  completed,
}

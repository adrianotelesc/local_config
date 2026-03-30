import 'package:local_config/src/domain/entities/local_config_update.dart';
import 'package:local_config/src/domain/entities/local_config_value.dart';
import 'package:local_config/src/domain/repositories/local_config_repository.dart';

class NoopLocalConfigRepositoryImpl implements LocalConfigRepository {
  @override
  Map<String, LocalConfigValue> get all => {};

  @override
  Map<String, String> get defaults => {};

  @override
  Map<String, String> get locals => {};

  @override
  Stream<LocalConfigUpdate> get onConfigUpdated => Stream.empty();

  @override
  Future<void> setDefaults(Map<String, String> defaultParameters) async {}

  @override
  LocalConfigValue? getValue(String key) => null;

  @override
  Future<void> set(String key, String value) async {}

  @override
  Future<void> reset(String key) async {}

  @override
  Future<void> resetAll() async {}
}

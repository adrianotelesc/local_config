import 'package:local_config/src/domain/entity/local_config_update.dart';
import 'package:local_config/src/domain/entity/local_config_value.dart';
import 'package:local_config/src/domain/repository/local_config_repository.dart';

class NoopLocalConfigRepositoryImpl implements LocalConfigRepository {
  @override
  Map<String, LocalConfigValue> get all => throw UnimplementedError();

  @override
  Future<void> clear() async {}

  @override
  LocalConfigValue? get(String key) => null;

  @override
  Stream<LocalConfigUpdate> get onConfigUpdated => Stream.empty();

  @override
  Future<void> remove(String key) async {}

  @override
  Future<void> set(String key, String value) async {}

  @override
  Future<void> setDefaults(Map<String, String> defaultParameters) async {}
}

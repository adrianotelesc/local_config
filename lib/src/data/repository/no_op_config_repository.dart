import 'package:local_config/src/domain/entity/config.dart';
import 'package:local_config/src/domain/repository/config_repository.dart';

class NoOpConfigRepository implements ConfigRepository {
  @override
  Map<String, LocalConfigValue> get configs => {};

  @override
  Stream<Map<String, LocalConfigValue>> get configsStream =>
      const Stream.empty();

  @override
  LocalConfigValue? get(String key) => null;

  @override
  Future<void> populate(Map<String, dynamic> defaults) async {}

  @override
  Future<void> reset(String key) async {}

  @override
  Future<void> resetAll() async {}

  @override
  Future<void> set(String key, dynamic value) async {}
}

import 'package:local_config/src/domain/entity/config.dart';
import 'package:local_config/src/domain/repository/config_repository.dart';

class NoOpConfigRepository implements ConfigRepository {
  @override
  Map<String, ConfigValue> get configs => {};

  @override
  Stream<Map<String, ConfigValue>> get configsStream => const Stream.empty();

  @override
  ConfigValue? get(String key) => null;

  @override
  Future<void> populate(Map<String, dynamic> defaults) async {}

  @override
  Future<void> reset(String key) async {}

  @override
  Future<void> resetAll() async {}

  @override
  Future<void> set(String key, dynamic value) async {}
}

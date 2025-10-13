import 'package:local_config/src/domain/entity/config.dart';
import 'package:local_config/src/domain/repository/config_repository.dart';

class NoOpConfigRepository implements ConfigRepository {
  @override
  Map<String, Config> get configs => {};

  @override
  Stream<Map<String, Config>> get configsStream => const Stream.empty();

  @override
  Config? get(String key) => null;

  @override
  Future<void> populate(Map<String, String> defaults) async {}

  @override
  Future<void> reset(String key) async {}

  @override
  Future<void> resetAll() async {}

  @override
  Future<void> set(String key, String value) async {}
}

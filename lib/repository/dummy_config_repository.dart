import 'package:local_config/model/config.dart';
import 'package:local_config/repository/config_repository.dart';

class DummyConfigRepository implements ConfigRepository {
  @override
  Future<Config?> get(String key) async => null;

  @override
  Future<void> populate({required Map<String, String> all}) async {}

  @override
  Future<void> reset(String key) async {}

  @override
  Future<void> resetAll() async {}

  @override
  Future<void> set(String key, String value) async {}

  @override
  Map<String, Config> get configs => {};

  @override
  Stream<Map<String, Config>> get configsStream => const Stream.empty();

  @override
  PopulateStatus get populateStatus => PopulateStatus.notStarted;

  @override
  Stream<PopulateStatus> get populateStatusStream => const Stream.empty();
}

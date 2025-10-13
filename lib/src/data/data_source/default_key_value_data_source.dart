import 'package:local_config/src/core/service/key_value_service.dart';
import 'package:local_config/src/data/data_source/key_value_data_source.dart';

class DefaultKeyValueDataSource extends KeyValueDataSource {
  final KeyValueService _service;

  DefaultKeyValueDataSource({
    required KeyValueService service,
  }) : _service = service;

  @override
  Future<Map<String, String>> get all async {
    final all = await _service.all;

    return all.map(
      (key, value) => MapEntry(key, value.toString()),
    );
  }

  @override
  Future<void> clear() async {
    final existingKeys = (await all).keys;

    for (final key in existingKeys) {
      await remove(key);
    }
  }

  @override
  Future<String?> get(String key) => _service.getString(key);

  @override
  Future<void> prune(Set<String> retainedKeys) async {
    final existingKeys = (await all).keys;

    for (final key in existingKeys) {
      if (!retainedKeys.contains(key)) {
        await remove(key);
      }
    }
  }

  @override
  Future<void> remove(String key) => _service.remove(key);

  @override
  Future<void> set(String key, String value) => _service.setString(key, value);
}

import 'package:local_config/src/core/storage/key_value_store.dart';
import 'package:local_config/src/data/data_source/key_value_data_source.dart';

class DefaultKeyValueDataSource extends KeyValueDataSource {
  final KeyValueStore _store;

  DefaultKeyValueDataSource({required KeyValueStore store}) : _store = store;

  @override
  Future<Map<String, String>> get all async {
    final all = await _store.all;
    return all.map((key, value) => MapEntry(key, value));
  }

  @override
  Future<void> clear() async {
    final existingKeys = (await all).keys;

    for (final key in existingKeys) {
      await remove(key);
    }
  }

  @override
  Future<String?> get(String key) => _store.getString(key);

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
  Future<void> remove(String key) => _store.remove(key);

  @override
  Future<void> set(String key, String value) => _store.setString(key, value);
}

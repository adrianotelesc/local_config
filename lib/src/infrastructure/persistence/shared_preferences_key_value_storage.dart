import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_config/src/core/persistence/key_value_storage.dart';

/// A KeyValueStorage implementation that uses SharedPreferences for data storage.
class SharedPreferencesKeyValueStorage extends KeyValueStorage {
  final SharedPreferencesAsync _sharedPreferences;

  SharedPreferencesKeyValueStorage({
    required SharedPreferencesAsync sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  @override
  Future<Map<String, String>> get all async {
    final all = await _sharedPreferences.getAll();
    return all.map((key, value) => MapEntry(key, value?.toString() ?? ''));
  }

  @override
  Future<String?> getString(String key) => _sharedPreferences.getString(key);

  @override
  Future<void> remove(String key) => _sharedPreferences.remove(key);

  @override
  Future<void> setString(String key, String value) =>
      _sharedPreferences.setString(key, value);

  @override
  Future<void> clear() => _sharedPreferences.clear();

  @override
  Future<void> prune(Set<String> retainedKeys) async {
    for (final key in (await all).keys) {
      if (!retainedKeys.contains(key)) {
        await _sharedPreferences.remove(key);
      }
    }
  }
}

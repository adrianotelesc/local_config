import 'package:local_config/src/core/storage/key_value_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesKeyValueStore extends KeyValueStore {
  final SharedPreferencesAsync _sharedPreferences;

  SharedPreferencesKeyValueStore({
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
}

import 'package:local_config/core/service/key_value_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesKeyValueService extends KeyValueService {
  final SharedPreferencesAsync _sharedPreferences;

  SharedPreferencesKeyValueService({
    required SharedPreferencesAsync sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  @override
  Future<Map<String, Object?>> get all => _sharedPreferences.getAll();

  @override
  Future<String?> getString(String key) => _sharedPreferences.getString(key);

  @override
  Future<void> setString(String key, String value) =>
      _sharedPreferences.setString(key, value);

  @override
  Future<void> remove(String key) => _sharedPreferences.remove(key);
}

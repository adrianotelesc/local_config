abstract class KeyValueStore {
  Future<Map<String, String>> get all;

  Future<String?> getString(String key);

  Future<void> setString(String key, String value);

  Future<void> remove(String key);
}

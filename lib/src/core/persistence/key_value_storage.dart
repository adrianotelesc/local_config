abstract class KeyValueStorage {
  Future<Map<String, String>> get all;

  Future<String?> getString(String key);

  Future<void> setString(String key, String value);

  Future<void> remove(String key);

  Future<void> prune(Set<String> retainedKeys);

  Future<void> clear();
}

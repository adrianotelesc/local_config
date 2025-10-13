abstract class KeyValueDataSource {
  Future<Map<String, String>> get all;

  Future<void> clear();

  Future<String?> get(String key);

  Future<void> prune(Set<String> retainedKeys);

  Future<void> remove(String key);

  Future<void> set(String key, String value);
}

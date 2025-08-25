abstract class KeyValueDataSource {
  Future<Map<String, String>> get all;

  Future<String?> get(String key);

  Future<void> set(String key, String value);

  Future<void> remove(String key);

  Future<void> clear();

  Future<void> prune(Set<String> keysToRetain);
}

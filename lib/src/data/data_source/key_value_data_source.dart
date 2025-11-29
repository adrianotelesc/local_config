abstract class KeyValueDataSource {
  Future<Map<String, dynamic>> get all;

  Future<void> clear();

  Future<dynamic> get(String key);

  Future<void> prune(Set<String> retainedKeys);

  Future<void> remove(String key);

  Future<void> set(String key, dynamic value);
}

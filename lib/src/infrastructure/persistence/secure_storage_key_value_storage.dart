import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_config/src/core/persistence/key_value_storage.dart';

/// A KeyValueStorage implementation that uses FlutterSecureStorage for secure data storage.
class SecureStorageKeyValueStorage implements KeyValueStorage {
  final FlutterSecureStorage _secureStorage;

  SecureStorageKeyValueStorage({required FlutterSecureStorage secureStorage})
    : _secureStorage = secureStorage;

  @override
  Future<Map<String, String>> get all => _secureStorage.readAll();

  @override
  Future<String?> getString(String key) => _secureStorage.read(key: key);

  @override
  Future<void> remove(String key) => _secureStorage.delete(key: key);

  @override
  Future<void> setString(String key, String value) =>
      _secureStorage.write(key: key, value: value);

  @override
  Future<void> clear() => _secureStorage.deleteAll();

  @override
  Future<void> prune(Set<String> retainedKeys) async {
    for (final key in (await all).keys) {
      if (!retainedKeys.contains(key)) {
        await _secureStorage.delete(key: key);
      }
    }
  }
}

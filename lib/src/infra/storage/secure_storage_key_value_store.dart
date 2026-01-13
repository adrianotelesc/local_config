import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_config/src/core/storage/key_value_store.dart';

class SecureStorageKeyValueStore implements KeyValueStore {
  final FlutterSecureStorage _secureStorage;

  SecureStorageKeyValueStore({required FlutterSecureStorage secureStorage})
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
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_config/core/service/key_value_service.dart';

class SecureStorageKeyValueService implements KeyValueService {
  final FlutterSecureStorage _secureStorage;

  SecureStorageKeyValueService({required FlutterSecureStorage secureStorage})
    : _secureStorage = secureStorage;

  @override
  Future<Map<String, Object?>> get all => _secureStorage.readAll();

  @override
  Future<String?> getString(String key) => _secureStorage.read(key: key);

  @override
  Future<void> remove(String key) => _secureStorage.delete(key: key);

  @override
  Future<void> setString(String key, String value) =>
      _secureStorage.write(key: key, value: value);
}

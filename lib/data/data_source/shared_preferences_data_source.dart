import 'package:local_config/domain/data_source/key_value_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesDataSource extends KeyValueDataSource {
  static const _namespace = 'local_config';

  final SharedPreferencesAsync _sharedPreferencesAsync;

  SharedPreferencesDataSource({
    required SharedPreferencesAsync sharedPreferencesAsync,
  }) : _sharedPreferencesAsync = sharedPreferencesAsync;

  String get _internalKeyPrefix => '$_namespace:';

  @override
  Future<Map<String, String>> get all async {
    final all = await _sharedPreferencesAsync.getAll();
    final internalEntries = all.entries
        .where((e) => _isInternalKey(e.key))
        .map((e) => MapEntry(_fromInternalKey(e.key), e.value.toString()));
    return Map<String, String>.fromEntries(internalEntries);
  }

  @override
  Future<String?> get(String key) {
    return _sharedPreferencesAsync.getString(_toInternalKey(key));
  }

  @override
  Future<void> set(String key, String value) {
    return _sharedPreferencesAsync.setString(_toInternalKey(key), value);
  }

  @override
  Future<void> remove(String key) {
    return _sharedPreferencesAsync.remove(_toInternalKey(key));
  }

  @override
  Future<void> clear() async {
    await Future.wait((await all).keys.map(remove));
  }

  @override
  Future<void> prune(Set<String> keysToRetain) async {
    final existingKeys = (await all).keys;
    final keysToRemove = existingKeys.where(
      (key) => !keysToRetain.contains(key),
    );
    await Future.wait(keysToRemove.map(remove));
  }

  bool _isInternalKey(String key) => key.startsWith(_internalKeyPrefix);

  String _toInternalKey(String key) => '$_internalKeyPrefix$key';

  String _fromInternalKey(String key) =>
      key.replaceFirst(_internalKeyPrefix, '');
}

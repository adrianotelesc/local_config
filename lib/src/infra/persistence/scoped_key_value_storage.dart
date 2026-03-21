import 'package:local_config/src/common/utils/case_validators.dart';
import 'package:local_config/src/core/persistence/key_value_storage.dart';
import 'package:local_config/src/infra/models/key_namespace.dart';

class ScopedKeyValueStorage implements KeyValueStorage {
  ScopedKeyValueStorage({
    required KeyNamespace namespace,
    required KeyValueStorage delegate,
  }) : _namespace = namespace,
       _delegate = delegate;

  final KeyNamespace _namespace;

  final KeyValueStorage _delegate;

  @override
  Future<Map<String, String>> get all async {
    final all = await _delegate.all;
    return {
      for (final entry in all.entries)
        if (_namespace.hasQualifiedPrefix(entry.key))
          _namespace.strip(entry.key): entry.value,
    };
  }

  @override
  Future<String?> getString(String key) =>
      _delegate.getString(_namespace.qualify(key));

  @override
  Future<void> setString(String key, String value) {
    if (!isSnakeCase(key)) {
      throw ArgumentError.value(
        key,
        'key',
        'because of namespace requirements, key must be snake_case',
      );
    }

    return _delegate.setString(_namespace.qualify(key), value);
  }

  @override
  Future<void> remove(String key) => _delegate.remove(_namespace.qualify(key));

  @override
  Future<void> prune(Set<String> retainedKeys) async {
    final all = await _delegate.all;

    for (final entry in all.entries) {
      final key = entry.key;

      if (!_namespace.hasBasePrefix(key)) continue;

      final isQualified = _namespace.hasQualifiedPrefix(key);

      if (!isQualified) {
        await _delegate.remove(key);
        continue;
      }

      if (!retainedKeys.contains(_namespace.strip(key))) {
        await _delegate.remove(key);
      }
    }
  }

  @override
  Future<void> clear() async {
    final all = await _delegate.all;
    for (final key in all.keys) {
      if (_namespace.hasBasePrefix(key)) {
        await _delegate.remove(key);
      }
    }
  }
}

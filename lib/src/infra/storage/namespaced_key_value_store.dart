import 'package:local_config/src/common/extensions/map_extension.dart';
import 'package:local_config/src/common/utils/case_validators.dart';
import 'package:local_config/src/core/storage/key_value_store.dart';
import 'package:local_config/src/infra/storage/key_namespace.dart';

class NamespacedKeyValueStore implements KeyValueStore {
  final KeyNamespace _namespace;
  final KeyValueStore _innerStore;

  NamespacedKeyValueStore({
    required KeyNamespace keyNamespace,
    required KeyValueStore innerStore,
  }) : _namespace = keyNamespace,
       _innerStore = innerStore;

  @override
  Future<Map<String, String>> get all async {
    final all = await _innerStore.all;
    final qualifiedAll = all.whereKey(_namespace.matchesQualified);
    return qualifiedAll.mapKeys(_namespace.strip);
  }

  @override
  Future<String?> getString(String key) =>
      _innerStore.getString(_namespace.qualify(key));

  @override
  Future<void> remove(String key) =>
      _innerStore.remove(_namespace.qualify(key));

  @override
  Future<void> setString(String key, String value) {
    if (!isSnakeCase(key)) {
      throw ArgumentError.value(
        key,
        'key',
        'The parameter key must start with an English letter or underscore character [A-Z, a-z], and may also include numbers',
      );
    }

    return _innerStore.setString(_namespace.qualify(key), value);
  }

  @override
  Future<void> clear() async {
    final all = await _innerStore.all;
    for (final key in all.keys) {
      if (_namespace.matchesBase(key)) {
        await _innerStore.remove(key);
      }
    }
  }

  @override
  Future<void> prune(Set<String> retainedKeys) async {
    final all = await _innerStore.all;
    final baseAll = all.whereKey(_namespace.matchesBase);
    for (final entry in baseAll.entries) {
      if (!retainedKeys.contains(_namespace.strip(entry.key)) ||
          !_namespace.matchesQualified(entry.key)) {
        await _innerStore.remove(entry.key);
      }
    }
  }
}

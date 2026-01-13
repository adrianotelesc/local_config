import 'package:local_config/src/common/extension/map_extension.dart';
import 'package:local_config/src/common/util/key_namespace.dart';
import 'package:local_config/src/core/storage/key_value_store.dart';

class NamespacedKeyValueStore implements KeyValueStore {
  final KeyNamespace _namespace;

  final KeyValueStore _inner;

  NamespacedKeyValueStore({
    required KeyNamespace namespace,
    required KeyValueStore inner,
  }) : _namespace = namespace,
       _inner = inner;

  @override
  Future<Map<String, String>> get all async {
    final all = await _inner.all;

    final namespaced = all
        .where((key, _) => _namespace.matches(key))
        .map((key, value) => MapEntry(_namespace.strip(key), value));

    return namespaced;
  }

  @override
  Future<String?> getString(String key) =>
      _inner.getString(_namespace.apply(key));

  @override
  Future<void> remove(String key) => _inner.remove(_namespace.apply(key));

  @override
  Future<void> setString(String key, String value) =>
      _inner.setString(_namespace.apply(key), value);
}

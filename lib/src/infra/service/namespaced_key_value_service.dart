import 'package:local_config/src/common/extension/map_extension.dart';
import 'package:local_config/src/common/util/key_namespace.dart';
import 'package:local_config/src/core/service/key_value_service.dart';

class NamespacedKeyValueService implements KeyValueService {
  final KeyNamespace _namespace;

  final KeyValueService _inner;

  NamespacedKeyValueService({
    required KeyNamespace namespace,
    required KeyValueService inner,
  }) : _namespace = namespace,
       _inner = inner;

  @override
  Future<Map<String, Object?>> get all async {
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

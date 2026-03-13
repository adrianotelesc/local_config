import 'package:local_config/src/common/extensions/map_extension.dart';
import 'package:local_config/src/common/extensions/string_extension.dart';
import 'package:local_config/src/common/utils/case_validators.dart';
import 'package:local_config/src/core/model/key_namespace.dart';
import 'package:local_config/src/core/storage/key_value_store.dart';
import 'package:local_config/src/data/data_source/key_value_data_source.dart';
import 'package:local_config/src/domain/policy/prune_policy.dart';

class DefaultKeyValueDataSource extends KeyValueDataSource {
  final KeyValueStore _store;
  final KeyNamespace _namespace;
  final KeyValuePrunePolicy _prunePolicy;

  DefaultKeyValueDataSource({
    required KeyNamespace namespace,
    required KeyValueStore store,
    required KeyValuePrunePolicy prunePolicy,
  }) : _namespace = namespace,
       _store = store,
       _prunePolicy = prunePolicy;

  @override
  Future<Map<String, String>> get all async {
    final all = await _store.all;
    return all.whereKey(_namespace.matchesQualified).mapKeys(_namespace.strip);
  }

  @override
  Future<void> clear() async {
    final all = await _store.all;
    for (final key in all.keys) {
      if (_namespace.matchesBase(key)) {
        await _store.remove(key);
      }
    }
  }

  @override
  Future<String?> get(String key) => _store.getString(_namespace.qualify(key));

  @override
  Future<void> set(String key, String value) async {
    if (isSnakeCase(key)) {
      throw ArgumentError.value(
        key,
        'key',
        'The parameter key must start with an English letter or underscore character [A-Z, a-z], and may also include numbers.',
      );
    }

    await _store.setString(_namespace.qualify(key), value);
  }

  @override
  Future<void> remove(String key) => _store.remove(_namespace.qualify(key));

  @override
  Future<void> prune(Map<String, String> retained) async {
    final all = await _store.all;
    for (final entry in all.whereKey(_namespace.matchesBase).entries) {
      if (_prunePolicy.shouldRemove(
        namespace: _namespace,
        entry: entry,
        retained: retained,
      )) {
        await _store.remove(entry.key);
      }
    }
  }
}

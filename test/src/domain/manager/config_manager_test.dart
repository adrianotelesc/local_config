import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/domain/manager/default_config_manager.dart';
import 'package:local_config/src/domain/entity/config.dart';

void main() {
  late DefaultConfigManager manager;

  setUp(() {
    manager = DefaultConfigManager();
  });

  group('populate', () {
    test('creates config values with defaults only', () {
      manager.populate({'a': '1', 'b': '2'}, {});

      expect(manager.configs['a']!.defaultValue, '1');
      expect(manager.configs['a']!.overriddenValue, null);
      expect(manager.configs['b']!.defaultValue, '2');
    });

    test('applies overrides when provided', () {
      manager.populate({'a': '1'}, {'a': '9'});

      final v = manager.configs['a']!;

      expect(v.defaultValue, '1');
      expect(v.overriddenValue, '9');
      expect(v.raw, '9');
    });

    test('adds entries to existing configs (does not clear)', () {
      manager.populate({'a': '1'}, {});
      manager.populate({'b': '2'}, {});

      expect(manager.configs.keys, containsAll(['a', 'b']));
    });
  });

  group('get', () {
    test('returns config when exists', () {
      manager.populate({'a': '1'}, {});

      final v = manager.get('a');

      expect(v, isNotNull);
      expect(v!.raw, '1');
    });

    test('returns null when missing', () {
      expect(manager.get('missing'), isNull);
    });
  });

  group('configs getter', () {
    test('returns unmodifiable map', () {
      manager.populate({'a': '1'}, {});

      final map = manager.configs;

      expect(
        () => map['x'] = const ConfigValue(defaultValue: 'x'),
        throwsUnsupportedError,
      );
    });
  });

  group('update', () {
    test('updates overridden value', () {
      manager.populate({'a': '1'}, {});

      final updated = manager.update('a', '2');

      expect(updated.overriddenValue, '2');
      expect(manager.configs['a']!.raw, '2');
    });

    test('can set overridden to null', () {
      manager.populate({'a': '1'}, {'a': '9'});

      final updated = manager.update('a', null);

      expect(updated.overriddenValue, null);
      expect(updated.isDefault, true);
    });
  });

  group('updateAll', () {
    test('clears all overrides', () {
      manager.populate({'a': '1', 'b': '2'}, {'a': '9', 'b': '8'});

      manager.updateAll(null);

      expect(manager.configs['a']!.overriddenValue, null);
      expect(manager.configs['b']!.overriddenValue, null);
      expect(manager.configs['a']!.isDefault, true);
      expect(manager.configs['b']!.isDefault, true);
    });
  });
}

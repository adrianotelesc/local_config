import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/domain/entity/config.dart';

void main() {
  group('ConfigValue', () {
    test('isDefault when overridden is null', () {
      const v = ConfigValue(defaultValue: '1');

      expect(v.isDefault, true);
      expect(v.isOverridden, false);
    });

    test('isDefault when overridden equals default', () {
      const v = ConfigValue(defaultValue: '1', overriddenValue: '1');

      expect(v.isDefault, true);
      expect(v.isOverridden, false);
    });

    test('isOverridden when different', () {
      const v = ConfigValue(defaultValue: '1', overriddenValue: '2');

      expect(v.isDefault, false);
      expect(v.isOverridden, true);
    });

    test('raw returns default when not overridden', () {
      const v = ConfigValue(defaultValue: 'abc');

      expect(v.raw, 'abc');
    });

    test('raw returns overridden when present', () {
      const v = ConfigValue(defaultValue: 'abc', overriddenValue: 'xyz');

      expect(v.raw, 'xyz');
    });

    group('type inference', () {
      test('boolean', () {
        const v = ConfigValue(defaultValue: 'true');
        expect(v.type, ConfigType.boolean);
      });

      test('number int', () {
        const v = ConfigValue(defaultValue: '10');
        expect(v.type, ConfigType.number);
      });

      test('number double', () {
        const v = ConfigValue(defaultValue: '1.5');
        expect(v.type, ConfigType.number);
      });

      test('json', () {
        const v = ConfigValue(defaultValue: '{"a":1}');
        expect(v.type, ConfigType.json);
      });

      test('string fallback', () {
        const v = ConfigValue(defaultValue: 'hello');
        expect(v.type, ConfigType.string);
      });
    });

    group('parsed', () {
      test('boolean', () {
        const v = ConfigValue(defaultValue: 'true');
        expect(v.parsed, true);
      });

      test('number', () {
        const v = ConfigValue(defaultValue: '10');
        expect(v.parsed, 10);
      });

      test('double', () {
        const v = ConfigValue(defaultValue: '1.5');
        expect(v.parsed, 1.5);
      });

      test('string', () {
        const v = ConfigValue(defaultValue: 'abc');
        expect(v.parsed, 'abc');
      });

      test('json map', () {
        const v = ConfigValue(defaultValue: '{"a":1}');
        final parsed = v.parsed as Map;

        expect(parsed['a'], 1);
      });

      test('parsed uses overridden value', () {
        const v = ConfigValue(defaultValue: '1', overriddenValue: '2');

        expect(v.parsed, 2);
      });
    });

    group('copyWith', () {
      test('creates new instance with new overridden', () {
        const v = ConfigValue(defaultValue: '1');

        final copy = v.copyWith(overriddenValue: '2');

        expect(copy.defaultValue, '1');
        expect(copy.overriddenValue, '2');
      });

      test('does not mutate original', () {
        const v = ConfigValue(defaultValue: '1');

        final copy = v.copyWith(overriddenValue: '2');

        expect(v.overriddenValue, null);
        expect(copy.overriddenValue, '2');
      });
    });

    group('equality', () {
      test('equal when values equal', () {
        const a = ConfigValue(defaultValue: '1', overriddenValue: '2');
        const b = ConfigValue(defaultValue: '1', overriddenValue: '2');

        expect(a, equals(b));
        expect(a.hashCode, b.hashCode);
      });

      test('not equal when overridden differs', () {
        const a = ConfigValue(defaultValue: '1', overriddenValue: '2');
        const b = ConfigValue(defaultValue: '1', overriddenValue: '3');

        expect(a, isNot(equals(b)));
      });
    });

    test('toString contains values', () {
      const v = ConfigValue(defaultValue: '1', overriddenValue: '2');

      expect(v.toString(), contains('1'));
      expect(v.toString(), contains('2'));
    });
  });

  group('ConfigType.inferFromValue', () {
    test('boolean first', () {
      expect(ConfigType.inferFromValue('true'), ConfigType.boolean);
    });

    test('number second', () {
      expect(ConfigType.inferFromValue('123'), ConfigType.number);
    });

    test('json third', () {
      expect(ConfigType.inferFromValue('{"a":1}'), ConfigType.json);
    });

    test('string fallback', () {
      expect(ConfigType.inferFromValue('abc'), ConfigType.string);
    });
  });

  group('ConfigType.isText', () {
    test('true for string', () {
      expect(ConfigType.string.isText, true);
    });

    test('true for json', () {
      expect(ConfigType.json.isText, true);
    });

    test('false for boolean', () {
      expect(ConfigType.boolean.isText, false);
    });

    test('false for number', () {
      expect(ConfigType.number.isText, false);
    });
  });
}

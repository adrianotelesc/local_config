import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/domain/entities/local_config_value.dart';

class TestingLocalConfigValue extends LocalConfigValue {
  TestingLocalConfigValue({required super.value, required super.source});
}

void main() {
  group('LocalConfigValue', () {
    group('asString', () {
      test('returns the raw string value', () {
        final config = TestingLocalConfigValue(
          value: 'hello',
          source: ValueSource.valueDefault,
        );
        expect(config.asString, equals('hello'));
      });

      test('returns empty string when value is empty', () {
        final config = TestingLocalConfigValue(
          value: '',
          source: ValueSource.valueDefault,
        );
        expect(config.asString, equals(''));
      });
    });

    group('asBool', () {
      test('returns true for "true"', () {
        final config = TestingLocalConfigValue(
          value: 'true',
          source: ValueSource.valueDefault,
        );
        expect(config.asBool, isTrue);
      });

      test('returns false for "false"', () {
        final config = TestingLocalConfigValue(
          value: 'false',
          source: ValueSource.valueDefault,
        );
        expect(config.asBool, isFalse);
      });

      test('returns null for non-bool string', () {
        final config = TestingLocalConfigValue(
          value: 'not_a_bool',
          source: ValueSource.valueDefault,
        );
        expect(config.asBool, isNull);
      });

      test('returns null for empty string', () {
        final config = TestingLocalConfigValue(
          value: '',
          source: ValueSource.valueDefault,
        );
        expect(config.asBool, isNull);
      });
    });

    group('asDouble', () {
      test('parses valid double string', () {
        final config = TestingLocalConfigValue(
          value: '3.14',
          source: ValueSource.valueDefault,
        );
        expect(config.asDouble, equals(3.14));
      });

      test('parses integer string as double', () {
        final config = TestingLocalConfigValue(
          value: '42',
          source: ValueSource.valueDefault,
        );
        expect(config.asDouble, equals(42.0));
      });

      test('parses negative double string', () {
        final config = TestingLocalConfigValue(
          value: '-1.5',
          source: ValueSource.valueDefault,
        );
        expect(config.asDouble, equals(-1.5));
      });

      test('returns null for non-numeric string', () {
        final config = TestingLocalConfigValue(
          value: 'abc',
          source: ValueSource.valueDefault,
        );
        expect(config.asDouble, isNull);
      });

      test('returns null for empty string', () {
        final config = TestingLocalConfigValue(
          value: '',
          source: ValueSource.valueDefault,
        );
        expect(config.asDouble, isNull);
      });
    });

    group('asInt', () {
      test('parses valid int string', () {
        final config = TestingLocalConfigValue(
          value: '10',
          source: ValueSource.valueDefault,
        );
        expect(config.asInt, equals(10));
      });

      test('parses negative int string', () {
        final config = TestingLocalConfigValue(
          value: '-7',
          source: ValueSource.valueDefault,
        );
        expect(config.asInt, equals(-7));
      });

      test('returns null for double string', () {
        final config = TestingLocalConfigValue(
          value: '3.14',
          source: ValueSource.valueDefault,
        );
        expect(config.asInt, isNull);
      });

      test('returns null for non-numeric string', () {
        final config = TestingLocalConfigValue(
          value: 'abc',
          source: ValueSource.valueDefault,
        );
        expect(config.asInt, isNull);
      });

      test('returns null for empty string', () {
        final config = TestingLocalConfigValue(
          value: '',
          source: ValueSource.valueDefault,
        );
        expect(config.asInt, isNull);
      });
    });

    group('asJson', () {
      test('parses valid JSON object string', () {
        final config = TestingLocalConfigValue(
          value: '{"key":"value"}',
          source: ValueSource.valueDefault,
        );
        expect(config.asJson, equals({'key': 'value'}));
      });

      test('parses valid JSON array string', () {
        final config = TestingLocalConfigValue(
          value: '[1,2,3]',
          source: ValueSource.valueDefault,
        );
        expect(config.asJson, equals([1, 2, 3]));
      });

      test('returns null for invalid JSON string', () {
        final config = TestingLocalConfigValue(
          value: 'not json',
          source: ValueSource.valueDefault,
        );
        expect(config.asJson, isNull);
      });

      test('returns null for empty string', () {
        final config = TestingLocalConfigValue(
          value: '',
          source: ValueSource.valueDefault,
        );
        expect(config.asJson, isNull);
      });
    });

    group('equality', () {
      test('two instances with same value and source are equal', () {
        final a = TestingLocalConfigValue(
          value: 'x',
          source: ValueSource.valueLocal,
        );
        final b = TestingLocalConfigValue(
          value: 'x',
          source: ValueSource.valueLocal,
        );
        expect(a, equals(b));
      });

      test('instances with different values are not equal', () {
        final a = TestingLocalConfigValue(
          value: 'x',
          source: ValueSource.valueLocal,
        );
        final b = TestingLocalConfigValue(
          value: 'y',
          source: ValueSource.valueLocal,
        );
        expect(a, isNot(equals(b)));
      });

      test('instances with different sources are not equal', () {
        final a = TestingLocalConfigValue(
          value: 'x',
          source: ValueSource.valueDefault,
        );
        final b = TestingLocalConfigValue(
          value: 'x',
          source: ValueSource.valueLocal,
        );
        expect(a, isNot(equals(b)));
      });

      test('identical instance is equal to itself', () {
        final a = TestingLocalConfigValue(
          value: 'x',
          source: ValueSource.valueDefault,
        );
        expect(a, equals(a));
      });
    });

    group('hashCode', () {
      test('equal instances have the same hashCode', () {
        final a = TestingLocalConfigValue(
          value: 'abc',
          source: ValueSource.valueDefault,
        );
        final b = TestingLocalConfigValue(
          value: 'abc',
          source: ValueSource.valueDefault,
        );
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different instances likely have different hashCodes', () {
        final a = TestingLocalConfigValue(
          value: 'abc',
          source: ValueSource.valueDefault,
        );
        final b = TestingLocalConfigValue(
          value: 'xyz',
          source: ValueSource.valueLocal,
        );
        expect(a.hashCode, isNot(equals(b.hashCode)));
      });
    });

    group('toString', () {
      test('returns the string value', () {
        final config = TestingLocalConfigValue(
          value: 'my_value',
          source: ValueSource.valueDefault,
        );
        expect(config.toString(), equals('my_value'));
      });
    });

    group('source', () {
      test('exposes valueDefault source correctly', () {
        final config = TestingLocalConfigValue(
          value: 'v',
          source: ValueSource.valueDefault,
        );
        expect(config.source, equals(ValueSource.valueDefault));
      });

      test('exposes valueLocal source correctly', () {
        final config = TestingLocalConfigValue(
          value: 'v',
          source: ValueSource.valueLocal,
        );
        expect(config.source, equals(ValueSource.valueLocal));
      });
    });
  });
}

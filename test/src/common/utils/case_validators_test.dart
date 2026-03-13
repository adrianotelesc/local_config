import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/common/utils/case_validators.dart';

void main() {
  group('keyValidate', () {
    test('accepts simple alphanumeric key', () {
      expect(() => isSnakeCase('abc123'), returnsNormally);
    });

    test('accepts allowed symbols', () {
      expect(() => isSnakeCase('a_b-c.d'), returnsNormally);
    });

    test('accepts mixed valid characters', () {
      expect(() => isSnakeCase('Config_1-prod.v2'), returnsNormally);
    });

    test('accepts single character', () {
      expect(() => isSnakeCase('a'), returnsNormally);
    });

    test('throws on empty string', () {
      expect(() => isSnakeCase(''), throwsA(isA<ArgumentError>()));
    });

    test('throws on space', () {
      expect(() => isSnakeCase('abc def'), throwsA(isA<ArgumentError>()));
    });

    test('throws on special characters', () {
      expect(() => isSnakeCase('abc@def'), throwsA(isA<ArgumentError>()));
    });

    test('throws on slash', () {
      expect(() => isSnakeCase('abc/def'), throwsA(isA<ArgumentError>()));
    });

    test('throws on unicode characters', () {
      expect(() => isSnakeCase('çãõ'), throwsA(isA<ArgumentError>()));
    });

    test('error contains correct parameter name', () {
      try {
        isSnakeCase('abc def');
        fail('should throw');
      } on ArgumentError catch (e) {
        expect(e.name, 'key');
      }
    });

    test('error contains invalid value', () {
      try {
        isSnakeCase('abc def');
        fail('should throw');
      } on ArgumentError catch (e) {
        expect(e.invalidValue, 'abc def');
      }
    });
  });
}

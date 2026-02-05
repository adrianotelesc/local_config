import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/common/util/key_validation.dart';

void main() {
  group('keyValidate', () {
    test('accepts simple alphanumeric key', () {
      expect(() => keyValidate('abc123'), returnsNormally);
    });

    test('accepts allowed symbols', () {
      expect(() => keyValidate('a_b-c.d'), returnsNormally);
    });

    test('accepts mixed valid characters', () {
      expect(() => keyValidate('Config_1-prod.v2'), returnsNormally);
    });

    test('accepts single character', () {
      expect(() => keyValidate('a'), returnsNormally);
    });

    test('throws on empty string', () {
      expect(() => keyValidate(''), throwsA(isA<ArgumentError>()));
    });

    test('throws on space', () {
      expect(() => keyValidate('abc def'), throwsA(isA<ArgumentError>()));
    });

    test('throws on special characters', () {
      expect(() => keyValidate('abc@def'), throwsA(isA<ArgumentError>()));
    });

    test('throws on slash', () {
      expect(() => keyValidate('abc/def'), throwsA(isA<ArgumentError>()));
    });

    test('throws on unicode characters', () {
      expect(() => keyValidate('çãõ'), throwsA(isA<ArgumentError>()));
    });

    test('error contains correct parameter name', () {
      try {
        keyValidate('abc def');
        fail('should throw');
      } on ArgumentError catch (e) {
        expect(e.name, 'key');
      }
    });

    test('error contains invalid value', () {
      try {
        keyValidate('abc def');
        fail('should throw');
      } on ArgumentError catch (e) {
        expect(e.invalidValue, 'abc def');
      }
    });
  });
}

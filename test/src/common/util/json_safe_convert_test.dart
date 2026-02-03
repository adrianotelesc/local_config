import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/common/util/json_safe_convert.dart';

void main() {
  group('tryJsonDecode', () {
    test('returns map for valid json object', () {
      const json = '{"a":1,"b":"x"}';

      final result = tryJsonDecode(json);

      expect(result, isA<Map<String, dynamic>>());
      expect(result?['a'], 1);
      expect(result?['b'], 'x');
    });

    test('returns null for invalid json', () {
      const json = '{"a":1,';

      final result = tryJsonDecode(json);

      expect(result, isNull);
    });

    test('returns null for non-json string', () {
      const json = 'not json';

      final result = tryJsonDecode(json);

      expect(result, isNull);
    });

    test('returns null when json is a list (not a map)', () {
      const json = '[1,2,3]';

      final result = tryJsonDecode(json);

      expect(result, isNull);
    });

    test('returns null when json is a primitive', () {
      const json = '123';

      final result = tryJsonDecode(json);

      expect(result, isNull);
    });

    test('returns null for empty string', () {
      final result = tryJsonDecode('');

      expect(result, isNull);
    });
  });

  group('tryJsonEncode', () {
    test('encodes map successfully', () {
      final obj = {'a': 1, 'b': 'x'};

      final result = tryJsonEncode(obj);

      expect(result, isNotNull);
      expect(result, contains('"a":1'));
      expect(result, contains('"b":"x"'));
    });

    test('encodes list successfully', () {
      final object = [1, 2, 3];

      final result = tryJsonEncode(object);

      expect(result, '[1,2,3]');
    });

    test('encodes primitive successfully', () {
      final result = tryJsonEncode(123);

      expect(result, '123');
    });

    test('returns null for non-encodable object', () {
      final object = Object();

      final result = tryJsonEncode(object);

      expect(result, isNull);
    });

    test('returns null for object with non-encodable value', () {
      final object = {'a': Object()};

      final result = tryJsonEncode(object);

      expect(result, isNull);
    });
  });
}

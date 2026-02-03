import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/common/extension/map_extension.dart';

void main() {
  group('MapExtension', () {
    group('where', () {
      test('filters by key and value', () {
        final map = {'a': 1, 'b': 2, 'c': 3};

        final result = map.where((k, v) => v.isEven);

        expect(result, {'b': 2});
      });

      test('returns empty map when none match', () {
        final map = {'a': 1, 'b': 3};

        final result = map.where((_, v) => v.isEven);

        expect(result, isEmpty);
      });
    });

    // ——————————————————————————

    group('whereKey', () {
      test('filters by key only', () {
        final map = {'apple': 1, 'banana': 2, 'avocado': 3};

        final result = map.whereKey((k) => k.startsWith('a'));

        expect(result, {'apple': 1, 'avocado': 3});
      });

      test('returns empty map when no key matches', () {
        final map = {'a': 1};

        final result = map.whereKey((k) => k == 'z');

        expect(result, isEmpty);
      });
    });

    // ——————————————————————————

    group('toRecordList', () {
      test('converts to list of records', () {
        final map = {'a': 1, 'b': 2};

        final result = map.toRecordList();

        expect(result, contains(('a', 1)));
        expect(result, contains(('b', 2)));
        expect(result.length, 2);
      });

      test('returns empty list for empty map', () {
        final result = <String, int>{}.toRecordList();

        expect(result, isEmpty);
      });
    });

    // ——————————————————————————

    group('anyValue', () {
      test('returns true when any value matches', () {
        final map = {'a': 1, 'b': 4};

        final result = map.anyValue((v) => v.isEven);

        expect(result, isTrue);
      });

      test('returns false when no value matches', () {
        final map = {'a': 1, 'b': 3};

        final result = map.anyValue((v) => v.isEven);

        expect(result, isFalse);
      });

      test('returns false for empty map', () {
        final result = <String, int>{}.anyValue((v) => true);

        expect(result, isFalse);
      });
    });

    // ——————————————————————————

    group('mapValues', () {
      test('maps values keeping keys', () {
        final map = {'a': 1, 'b': 2};

        final result = map.mapValues((v) => 'num:$v');

        expect(result, {'a': 'num:1', 'b': 'num:2'});
      });

      test('supports type change', () {
        final map = {'a': 1};

        final result = map.mapValues((v) => v.toDouble());

        expect(result['a'], 1.0);
      });
    });

    // ——————————————————————————

    group('mapKeys', () {
      test('maps keys keeping values', () {
        final map = {'a': 1, 'b': 2};

        final result = map.mapKeys((k) => k.toUpperCase());

        expect(result, {'A': 1, 'B': 2});
      });

      test('supports key type change', () {
        final map = {'1': 'a', '2': 'b'};

        final result = map.mapKeys(int.parse);

        expect(result, {1: 'a', 2: 'b'});
      });
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/common/extension/map_extension.dart';

void main() {
  group('MapExtension.whereKey', () {
    final map = {'a': 1, 'b': 2, 'c': 3};

    test('returns filtered Map by key', () {
      final result = map.where((key, value) => key != 'b');

      expect(result.length, 2);
      expect(result.containsKey('a'), isTrue);
      expect(result.containsKey('c'), isTrue);
      expect(result.containsKey('b'), isFalse);
    });

    test('returns empty map when no keys pass test', () {
      final result = map.where((key, value) => key == 'z');

      expect(result, isEmpty);
    });

    test('returns full map when all keys pass test', () {
      final result = map.where((key, value) => true);

      expect(result, map);
    });
  });

  group('MapExtension.toRecordList', () {
    test('returns list of (key, value) tuples', () {
      const map = {'a': 1, 'b': 2, 'c': 3};

      final result = map.toRecordList();

      expect(result.length, 3);
      expect(result, contains(('a', 1)));
      expect(result, contains(('b', 2)));
      expect(result, contains(('c', 3)));
    });

    test('returns empty list for empty map', () {
      const map = {};

      final result = map.toRecordList();

      expect(result, isEmpty);
    });
  });

  group('MapExtension.anyValue', () {
    const map = {'a': 1, 'b': 2, 'c': 3};

    test('returns true when map has any value passes test', () {
      final result = map.anyValue((value) => value > 2);

      expect(result, isTrue);
    });

    test('returns false when map has none value passes test', () {
      final result = map.anyValue((value) => value > 5);

      expect(result, isFalse);
    });

    test('returns false when map is empty', () {
      const map = {};

      final result = map.anyValue((value) => true);

      expect(result, isFalse);
    });
  });
}

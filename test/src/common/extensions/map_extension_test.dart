import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/common/extensions/map_extension.dart';

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
  });
}

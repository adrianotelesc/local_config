import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:local_config/src/core/storage/key_value_store.dart';
import 'package:local_config/src/data/data_source/default_key_value_data_source.dart';

class MockKeyValueStore extends Mock implements KeyValueStore {}

void main() {
  late MockKeyValueStore store;
  late DefaultKeyValueDataSource dataSource;

  setUpAll(() {
    registerFallbackValue(const MapEntry<String, String>('k', 'v'));
  });

  setUp(() {
    store = MockKeyValueStore();

    dataSource = DefaultKeyValueDataSource(store: store);
  });

  group('all', () {
    test('returns only qualified keys stripped', () async {
      when(() => store.all).thenAnswer(
        (_) async => {
          'cfg_v1_a': '1',
          'cfg_v1_b': '2',
          'cfg_x_c': '3',
          'other': '4',
        },
      );

      final result = await dataSource.all;

      expect(result, {'a': '1', 'b': '2'});
    });
  });

  group('get', () {
    test('qualifies key before reading', () async {
      when(() => store.getString(any())).thenAnswer((_) async => 'dark');

      final value = await dataSource.get('theme');

      expect(value, 'dark');
      verify(() => store.getString('cfg_v1_theme')).called(1);
    });
  });

  group('set', () {
    test('qualifies key before writing', () async {
      when(() => store.setString(any(), any())).thenAnswer((_) async {});

      await dataSource.set('theme', 'x');

      verify(() => store.setString('cfg_v1_theme', 'x')).called(1);
    });

    test('throws ArgumentError for invalid key', () async {
      expect(() => dataSource.set('Invalid-Key', 'value'), throwsArgumentError);

      verifyNever(() => store.setString(any(), any()));
    });
  });

  group('remove', () {
    test('qualifies key before removing', () async {
      when(() => store.remove(any())).thenAnswer((_) async {});

      await dataSource.remove('theme');

      verify(() => store.remove('cfg_v1_theme')).called(1);
    });
  });

  group('clear', () {
    test('removes only base-matching keys', () async {
      when(() => store.all).thenAnswer(
        (_) async => {'cfg_v1_a': '1', 'cfg_v2_b': '2', 'other': '3'},
      );

      when(() => store.remove(any())).thenAnswer((_) async {});

      await dataSource.clear();

      verify(() => store.remove('cfg_v1_a')).called(1);
      verify(() => store.remove('cfg_v2_b')).called(1);
      verifyNever(() => store.remove('other'));
    });
  });

  group('prune', () {
    test('removes keys when policy says true', () async {
      when(() => store.all).thenAnswer(
        (_) async => {'cfg_v1_a': '1', 'cfg_v1_b': '2', 'other': '3'},
      );

      when(() => store.remove(any())).thenAnswer((_) async {});

      await dataSource.prune({'a'});

      verify(() => store.remove('cfg_v1_b')).called(1);
      verifyNever(() => store.remove('cfg_v1_a'));
      verifyNever(() => store.remove('other'));
    });
  });
}

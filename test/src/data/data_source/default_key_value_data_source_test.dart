import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/core/storage/key_value_store.dart';
import 'package:local_config/src/data/data_source/default_key_value_data_source.dart';
import 'package:mocktail/mocktail.dart';

class MockKeyValueStore extends Mock implements KeyValueStore {}

void main() {
  late MockKeyValueStore store;
  late DefaultKeyValueDataSource dataSource;

  setUp(() {
    store = MockKeyValueStore();
    dataSource = DefaultKeyValueDataSource(store: store);
  });

  group('DefaultConfigDataSource', () {
    test('get() delegates to KeyValueStore.getString()', () async {
      when(() => store.getString('theme')).thenAnswer((_) async => 'dark');

      final result = await dataSource.get('theme');

      expect(result, 'dark');
      verify(() => store.getString('theme')).called(1);
    });

    test('set() delegates to KeyValueStore.setString()', () async {
      when(() => store.setString('theme', 'light')).thenAnswer((_) async {});

      await dataSource.set('theme', 'light');

      verify(() => store.setString('theme', 'light')).called(1);
    });

    test('remove() delegates to KeyValueStore.remove()', () async {
      when(() => store.remove('theme')).thenAnswer((_) async {});

      await dataSource.remove('theme');

      verify(() => store.remove('theme')).called(1);
    });

    test('all returns stringified map from KeyValueStore', () async {
      when(
        () => store.all,
      ).thenAnswer((_) async => {'a': '1', 'b': 'true', 'c': 'str'});

      final result = await dataSource.all;

      expect(result, {'a': '1', 'b': 'true', 'c': 'str'});
      verify(() => store.all).called(1);
    });

    test('clear removes all existing keys', () async {
      when(
        () => store.all,
      ).thenAnswer((_) async => {'a': '1', 'b': '2', 'c': '3'});
      when(() => store.remove(any())).thenAnswer((_) async {});

      await dataSource.clear();

      verify(() => store.remove('a')).called(1);
      verify(() => store.remove('b')).called(1);
      verify(() => store.remove('c')).called(1);
    });

    test('prune removes only non-retained keys', () async {
      when(
        () => store.all,
      ).thenAnswer((_) async => {'a': '1', 'b': '2', 'c': '3'});
      when(() => store.remove(any())).thenAnswer((_) async {});

      await dataSource.prune({'a', 'c'});

      verifyNever(() => store.remove('a'));
      verify(() => store.remove('b')).called(1);
      verifyNever(() => store.remove('c'));
    });

    test('clear does nothing when store is empty', () async {
      when(() => store.all).thenAnswer((_) async => {});
      // No removes expected
      await dataSource.clear();

      verifyNever(() => store.remove(any()));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/core/service/key_value_service.dart';
import 'package:local_config/data/data_source/default_config_data_source.dart';
import 'package:mocktail/mocktail.dart';

class MockKeyValueService extends Mock implements KeyValueService {}

void main() {
  late MockKeyValueService mockService;
  late DefaultKeyValueDataSource dataSource;

  setUp(() {
    mockService = MockKeyValueService();
    dataSource = DefaultKeyValueDataSource(service: mockService);
  });

  group('DefaultConfigDataSource', () {
    test('get() delegates to KeyValueService.getString()', () async {
      when(
        () => mockService.getString('theme'),
      ).thenAnswer((_) async => 'dark');

      final result = await dataSource.get('theme');

      expect(result, 'dark');
      verify(() => mockService.getString('theme')).called(1);
    });

    test('set() delegates to KeyValueService.setString()', () async {
      when(
        () => mockService.setString('theme', 'light'),
      ).thenAnswer((_) async {});

      await dataSource.set('theme', 'light');

      verify(() => mockService.setString('theme', 'light')).called(1);
    });

    test('remove() delegates to KeyValueService.remove()', () async {
      when(() => mockService.remove('theme')).thenAnswer((_) async {});

      await dataSource.remove('theme');

      verify(() => mockService.remove('theme')).called(1);
    });

    test('all returns stringified map from KeyValueService', () async {
      when(() => mockService.all).thenAnswer(
        (_) async => {'a': 1, 'b': true, 'c': 'str'},
      );

      final result = await dataSource.all;

      expect(result, {'a': '1', 'b': 'true', 'c': 'str'});
      verify(() => mockService.all).called(1);
    });

    test('clear removes all existing keys', () async {
      when(
        () => mockService.all,
      ).thenAnswer((_) async => {'a': '1', 'b': '2', 'c': '3'});
      when(() => mockService.remove(any())).thenAnswer((_) async {});

      await dataSource.clear();

      verify(() => mockService.remove('a')).called(1);
      verify(() => mockService.remove('b')).called(1);
      verify(() => mockService.remove('c')).called(1);
    });

    test('prune removes only non-retained keys', () async {
      when(
        () => mockService.all,
      ).thenAnswer((_) async => {'a': '1', 'b': '2', 'c': '3'});
      when(() => mockService.remove(any())).thenAnswer((_) async {});

      await dataSource.prune({'a', 'c'});

      verifyNever(() => mockService.remove('a'));
      verify(() => mockService.remove('b')).called(1);
      verifyNever(() => mockService.remove('c'));
    });

    test('clear does nothing when service is empty', () async {
      when(() => mockService.all).thenAnswer((_) async => {});
      // No removes expected
      await dataSource.clear();

      verifyNever(() => mockService.remove(any()));
    });
  });
}

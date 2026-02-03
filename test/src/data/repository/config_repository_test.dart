import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:local_config/src/data/data_source/key_value_data_source.dart';
import 'package:local_config/src/data/repository/default_config_repository.dart';
import 'package:local_config/src/domain/entity/config.dart';
import 'package:local_config/src/domain/manager/config_manager.dart';

class MockDataSource extends Mock implements KeyValueDataSource {}

class MockManager extends Mock implements ConfigManager {}

void main() {
  late MockDataSource dataSource;
  late MockManager manager;
  late DefaultConfigRepository repo;

  setUp(() {
    dataSource = MockDataSource();
    manager = MockManager();

    repo = DefaultConfigRepository(dataSource: dataSource, manager: manager);
  });

  group('populate', () {
    test('calls prune, loads overrides, populates manager and emits', () async {
      when(() => dataSource.prune(any())).thenAnswer((_) async {});
      when(() => dataSource.all).thenAnswer((_) async => {'a': '2'});
      when(() => manager.populate(any(), any())).thenReturn(null);
      when(() => manager.configs).thenReturn({});

      expectLater(repo.configsStream, emits(isA<Map<String, ConfigValue>>()));

      await repo.populate({'a': '1'});

      verify(() => dataSource.prune({'a': '1'})).called(1);
      verify(() => manager.populate({'a': '1'}, {'a': '2'})).called(1);
    });
  });

  group('get', () {
    test('delegates to manager', () {
      when(() => manager.get('k')).thenReturn(null);

      repo.get('k');

      verify(() => manager.get('k')).called(1);
    });
  });

  group('configs getter', () {
    test('delegates to manager', () {
      when(() => manager.configs).thenReturn({});

      repo.configs;

      verify(() => manager.configs).called(1);
    });
  });

  group('remove', () {
    test('updates manager, removes datasource, emits', () async {
      when(
        () => manager.update('a', null),
      ).thenReturn(ConfigValue(defaultValue: '1'));
      when(() => dataSource.remove('a')).thenAnswer((_) async {});
      when(() => manager.configs).thenReturn({});

      expectLater(repo.configsStream, emits(isA<Map<String, ConfigValue>>()));

      await repo.remove('a');

      verify(() => manager.update('a', null)).called(1);
      verify(() => dataSource.remove('a')).called(1);
    });
  });

  group('clear', () {
    test('updates all, clears datasource, emits', () async {
      when(() => manager.updateAll(null)).thenReturn(null);
      when(() => dataSource.clear()).thenAnswer((_) async {});
      when(() => manager.configs).thenReturn({});

      expectLater(repo.configsStream, emits(isA<Map<String, ConfigValue>>()));

      await repo.clear();

      verify(() => manager.updateAll(null)).called(1);
      verify(() => dataSource.clear()).called(1);
    });
  });

  group('set', () {
    test('writes to datasource when overridden', () async {
      final overridden = ConfigValue(defaultValue: '1', overriddenValue: '2');

      when(() => manager.update('a', '2')).thenReturn(overridden);
      when(() => dataSource.set('a', '2')).thenAnswer((_) async {});
      when(() => manager.configs).thenReturn({});

      expectLater(repo.configsStream, emits(isA<Map<String, ConfigValue>>()));

      await repo.set('a', '2');

      verify(() => dataSource.set('a', '2')).called(1);
      verifyNever(() => dataSource.remove(any()));
    });

    test('removes from datasource when not overridden', () async {
      final baseline = ConfigValue(defaultValue: '1', overriddenValue: null);

      when(() => manager.update('a', '1')).thenReturn(baseline);
      when(() => dataSource.remove('a')).thenAnswer((_) async {});
      when(() => manager.configs).thenReturn({});

      expectLater(repo.configsStream, emits(isA<Map<String, ConfigValue>>()));

      await repo.set('a', '1');

      verify(() => dataSource.remove('a')).called(1);
      verifyNever(() => dataSource.set(any(), any()));
    });
  });
}

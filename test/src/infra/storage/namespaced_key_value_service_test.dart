import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/core/service/key_value_service.dart';
import 'package:local_config/infra/service/namespaced_key_value_service.dart';
import 'package:local_config/infra/util/key_namespace.dart';
import 'package:mocktail/mocktail.dart';

class MockKeyNamespace extends Mock implements KeyNamespace {}

class MockKeyValueService extends Mock implements KeyValueService {}

void main() {
  late MockKeyNamespace mockKeyNamespace;
  late MockKeyValueService mockInnerService;
  late NamespacedKeyValueService service;

  setUp(() {
    mockInnerService = MockKeyValueService();
    mockKeyNamespace = MockKeyNamespace();

    service = NamespacedKeyValueService(
      namespace: mockKeyNamespace,
      inner: mockInnerService,
    );
  });

  group('NamespacedKeyValueService.all', () {
    test('returns only namespaced keys with prefix removed', () async {
      const all = {
        'ns:foo': 'bar',
        'other:key': 'value',
      };

      when(() => mockInnerService.all).thenAnswer((_) async => all);
      when(() => mockKeyNamespace.matches('ns:foo')).thenReturn(true);
      when(() => mockKeyNamespace.matches('other:key')).thenReturn(false);
      when(() => mockKeyNamespace.strip('ns:foo')).thenReturn('foo');

      final result = await service.all;

      expect(result.length, 1);
      expect(result['foo'], 'bar');
      expect(result.containsKey('other:key'), isFalse);
    });

    test('returns empty map when no namespaced keys', () async {
      const all = {'other:key': 'value'};

      when(() => mockInnerService.all).thenAnswer((_) async => all);
      when(() => mockKeyNamespace.matches('other:key')).thenReturn(false);

      final result = await service.all;

      expect(result, isEmpty);
    });
  });

  group('NamespacedKeyValueService.getString', () {
    test('applies namespace and delegates to inner service', () async {
      const key = 'foo';
      const namespacedKey = 'ns:foo';
      const value = 'bar';

      when(() => mockKeyNamespace.apply(key)).thenReturn(namespacedKey);
      when(
        () => mockInnerService.getString(namespacedKey),
      ).thenAnswer((_) async => value);

      final result = await service.getString(key);

      expect(result, value);
      verify(() => mockKeyNamespace.apply(key)).called(1);
      verify(() => mockInnerService.getString(namespacedKey)).called(1);
    });
  });

  group('NamespacedKeyValueService.setString', () {
    test('applies namespace and delegates to inner service', () async {
      const key = 'foo';
      const value = 'bar';
      const namespacedKey = 'ns:foo';

      when(() => mockKeyNamespace.apply(key)).thenReturn(namespacedKey);
      when(
        () => mockInnerService.setString(namespacedKey, value),
      ).thenAnswer((_) async {});

      await service.setString(key, value);

      verify(() => mockKeyNamespace.apply(key)).called(1);
      verify(() => mockInnerService.setString(namespacedKey, value)).called(1);
    });
  });

  group('NamespacedKeyValueService.remove', () {
    test('applies namespace and delegates to inner service', () async {
      const key = 'foo';
      const namespacedKey = 'ns:foo';

      when(() => mockKeyNamespace.apply(key)).thenReturn(namespacedKey);
      when(
        () => mockInnerService.remove(namespacedKey),
      ).thenAnswer((_) async {});

      await service.remove(key);

      verify(() => mockKeyNamespace.apply(key)).called(1);
      verify(() => mockInnerService.remove(namespacedKey)).called(1);
    });
  });
}

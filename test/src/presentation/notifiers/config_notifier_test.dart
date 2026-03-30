import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/domain/repositories/local_config_repository.dart';
import 'package:local_config/src/presentation/notifiers/config_notifier.dart';

import '../../data/repositories/fake_local_config_repository_impl.dart';

void main() {
  late LocalConfigRepository repo;
  late ConfigNotifier notifier;

  setUp(() async {
    repo = FakeLocalConfigRepositoryImpl();
    await repo.setDefaults({
      'a': '1',
      'b': '2',
    });

    notifier = ConfigNotifier(configRepo: repo);
  });

  tearDown(() {
    notifier.dispose();
  });

  group('initialization', () {
    test('should load configs on initialization', () {
      expect(notifier.all.keys, {'a', 'b'});
      expect(notifier.filtered.length, 2);
    });
  });

  group('refresh', () {
    test('should update items when repository changes', () async {
      await repo.set('a', '10');

      await Future.delayed(Duration.zero);

      expect(notifier.get('a')?.effectiveValue, '10');
    });
  });

  group('showOnlyOverrides', () {
    test('should filter only overridden values when enabled', () async {
      await repo.set('a', '10');
      await Future.delayed(Duration.zero);

      notifier.showOnlyLocals = true;

      expect(notifier.filtered.length, 1);
      expect(notifier.filtered.first.key, 'a');
    });

    test('should include all values when disabled', () {
      notifier.showOnlyLocals = false;

      expect(notifier.filtered.length, 2);
    });
  });

  group('query', () {
    test('should filter items by key', () {
      notifier.query('a');

      expect(notifier.filtered.length, 1);
      expect(notifier.filtered.first.key, 'a');
    });

    test('should filter items by value', () {
      notifier.query('1');

      expect(notifier.filtered.length, 1);
      expect(notifier.filtered.first.key, 'a');
    });

    test('should support multiple search terms', () {
      notifier.query('a 1');

      expect(notifier.filtered.length, 1);
    });

    test('should return empty when no match found', () {
      notifier.query('xyz');

      expect(notifier.filtered, isEmpty);
    });
  });

  group('terms', () {
    test('should split query into terms', () {
      notifier.query('a b');

      expect(notifier.terms, {'a', 'b'});
    });
  });

  group('hasOverrides', () {
    test('should return false when no overrides exist', () {
      expect(notifier.hasLocalValue, isFalse);
    });

    test('should return true when at least one override exists', () async {
      await repo.set('a', '10');
      await Future.delayed(Duration.zero);

      expect(notifier.hasLocalValue, isTrue);
    });
  });

  group('listeners', () {
    test('should notify listeners on refresh', () async {
      var notified = false;
      notifier.addListener(() => notified = true);

      notifier.refresh();

      expect(notified, isTrue);
    });

    test('should notify listeners on query change', () {
      var notified = false;
      notifier.addListener(() => notified = true);

      notifier.query('a');

      expect(notified, isTrue);
    });

    test('should notify listeners when showOnlyOverrides changes', () {
      var notified = false;
      notifier.addListener(() => notified = true);

      notifier.showOnlyLocals = true;

      expect(notified, isTrue);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/common/util/key_namespace.dart';

void main() {
  group('KeyNamespace', () {
    test('throws assertion error when namespace is empty', () {
      expect(
        () => KeyNamespace(namespace: ''),
        throwsA(isA<AssertionError>()),
      );
    });

    test('throws assertion error when separator is empty', () {
      expect(
        () => KeyNamespace(namespace: 'app', separator: ''),
        throwsA(isA<AssertionError>()),
      );
    });

    test('uses default separator ":" when not provided', () {
      final ns = KeyNamespace(namespace: 'user');
      expect(ns.apply('token'), 'user:token');
    });

    test('apply() prefixes key with namespace and separator', () {
      final ns = KeyNamespace(namespace: 'config', separator: '_');

      final result = ns.apply('theme');

      expect(result, 'config_theme');
    });

    test('matches() returns true when key starts with namespace prefix', () {
      final ns = KeyNamespace(namespace: 'settings');
      expect(ns.matches('settings:theme'), isTrue);
    });

    test('matches() returns false when key does not start with namespace', () {
      final ns = KeyNamespace(namespace: 'settings');
      expect(ns.matches('theme'), isFalse);
    });

    test('strip() removes namespace prefix only once', () {
      final ns = KeyNamespace(namespace: 'data', separator: '-');

      final result = ns.strip('data-key');

      expect(result, 'key');
    });

    test('strip() returns same key if prefix not present', () {
      final ns = KeyNamespace(namespace: 'data', separator: '-');

      final result = ns.strip('other-key');

      expect(result, 'other-key');
    });

    test('matches, apply and strip are consistent together', () {
      final ns = KeyNamespace(namespace: 'cfg');

      const key = 'theme';
      final namespaced = ns.apply(key);

      expect(ns.matches(namespaced), isTrue);
      expect(ns.strip(namespaced), key);
    });

    test('works correctly with multi-character separator', () {
      final ns = KeyNamespace(namespace: 'myApp', separator: '::');

      const key = 'token';
      final result = ns.apply(key);

      expect(result, 'myApp::token');
      expect(ns.matches(result), isTrue);
      expect(ns.strip(result), 'token');
    });
  });
}

import 'package:flutter_test/flutter_test.dart';

import 'package:local_config/src/core/model/key_namespace.dart';
import 'package:local_config/src/domain/policy/missing_retained_key_prune_policy.dart';

void main() {
  late MissingRetainedKeyPrunePolicy policy;

  setUp(() {
    policy = MissingRetainedKeyPrunePolicy();
  });

  test('removes when stripped key not in retained', () {
    final ns = KeyNamespace(base: 'cfg', segments: ['v1']);

    final entry = const MapEntry('cfg_v1_theme', 'dark');

    final result = policy.shouldRemove(
      namespace: ns,
      entry: entry,
      retained: const {},
    );

    expect(result, true);
  });

  test('does not remove when stripped key exists', () {
    final ns = KeyNamespace(base: 'cfg', segments: ['v1']);

    final entry = const MapEntry('cfg_v1_theme', 'dark');

    final result = policy.shouldRemove(
      namespace: ns,
      entry: entry,
      retained: const {'theme': 'light'},
    );

    expect(result, false);
  });

  test('works with base-only namespace', () {
    final ns = KeyNamespace(base: 'cfg');

    final entry = const MapEntry('cfg_theme', 'x');

    final result = policy.shouldRemove(
      namespace: ns,
      entry: entry,
      retained: const {'theme': 'y'},
    );

    expect(result, false);
  });

  test('removes when retained has other keys only', () {
    final ns = KeyNamespace(base: 'cfg', segments: ['v1']);

    final entry = const MapEntry('cfg_v1_theme', 'x');

    final result = policy.shouldRemove(
      namespace: ns,
      entry: entry,
      retained: const {'other': 'x'},
    );

    expect(result, true);
  });

  test('value difference does not matter — only key presence', () {
    final ns = KeyNamespace(base: 'cfg', segments: ['v1']);

    final entry = const MapEntry('cfg_v1_theme', 'dark');

    final result = policy.shouldRemove(
      namespace: ns,
      entry: entry,
      retained: const {'theme': 'light'},
    );

    expect(result, false);
  });
}

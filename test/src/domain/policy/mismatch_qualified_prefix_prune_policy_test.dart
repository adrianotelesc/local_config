import 'package:flutter_test/flutter_test.dart';

import 'package:local_config/src/core/model/key_namespace.dart';
import 'package:local_config/src/domain/policy/mismatch_qualified_prefix_prune_policy.dart';

void main() {
  late MismatchQualifiedPrefixPrunePolicy policy;

  setUp(() {
    policy = MismatchQualifiedPrefixPrunePolicy();
  });

  test('does not remove when key matches qualified prefix', () {
    final ns = KeyNamespace(base: 'cfg', segments: ['v1']);

    final entry = const MapEntry('cfg_v1_theme', 'x');

    final result = policy.shouldRemove(
      namespace: ns,
      entry: entry,
      retained: const {},
    );

    expect(result, false);
  });

  test('removes when key matches only base prefix', () {
    final ns = KeyNamespace(base: 'cfg', segments: ['v1']);

    final entry = const MapEntry('cfg_theme', 'x');

    final result = policy.shouldRemove(
      namespace: ns,
      entry: entry,
      retained: const {},
    );

    expect(result, true);
  });

  test('removes when key belongs to another qualified namespace', () {
    final ns = KeyNamespace(base: 'cfg', segments: ['v2']);

    final entry = const MapEntry('cfg_v1_theme', 'x');

    final result = policy.shouldRemove(
      namespace: ns,
      entry: entry,
      retained: const {},
    );

    expect(result, true);
  });

  test('removes when key has completely different prefix', () {
    final ns = KeyNamespace(base: 'cfg', segments: ['v1']);

    final entry = const MapEntry('other_theme', 'x');

    final result = policy.shouldRemove(
      namespace: ns,
      entry: entry,
      retained: const {},
    );

    expect(result, true);
  });

  test('namespace without segments treats base as qualified', () {
    final ns = KeyNamespace(base: 'cfg');

    final entry = const MapEntry('cfg_theme', 'x');

    final result = policy.shouldRemove(
      namespace: ns,
      entry: entry,
      retained: const {},
    );

    expect(result, false);
  });
}

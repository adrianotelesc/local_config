import 'package:flutter_test/flutter_test.dart';

import 'package:local_config/src/core/model/key_namespace.dart';
import 'package:local_config/src/domain/policy/baseline_value_prune_policy.dart';

void main() {
  late BaselineValuePrunePolicy policy;
  late KeyNamespace ns;

  setUp(() {
    policy = BaselineValuePrunePolicy();
    ns = KeyNamespace(base: 'cfg', segments: ['v1']);
  });

  test('removes when stored value equals retained baseline', () {
    final entry = const MapEntry('cfg_v1_theme', 'dark');

    final retained = {'theme': 'dark'};

    final result = policy.shouldRemove(
      namespace: ns,
      entry: entry,
      retained: retained,
    );

    expect(result, true);
  });

  test('does not remove when values differ', () {
    final entry = const MapEntry('cfg_v1_theme', 'dark');

    final retained = {'theme': 'light'};

    final result = policy.shouldRemove(
      namespace: ns,
      entry: entry,
      retained: retained,
    );

    expect(result, false);
  });

  test('does not remove when key missing in retained', () {
    final entry = const MapEntry('cfg_v1_theme', 'dark');

    final retained = <String, String>{};

    final result = policy.shouldRemove(
      namespace: ns,
      entry: entry,
      retained: retained,
    );

    expect(result, false);
  });

  test('works when key has only base prefix', () {
    final baseNs = KeyNamespace(base: 'cfg');

    final entry = const MapEntry('cfg_theme', 'x');

    final retained = {'theme': 'x'};

    final result = policy.shouldRemove(
      namespace: baseNs,
      entry: entry,
      retained: retained,
    );

    expect(result, true);
  });

  test(
    'does not remove when stripped key maps to different retained entry',
    () {
      final entry = const MapEntry('cfg_v1_theme', 'dark');

      final retained = {'other': 'dark'};

      final result = policy.shouldRemove(
        namespace: ns,
        entry: entry,
        retained: retained,
      );

      expect(result, false);
    },
  );
}

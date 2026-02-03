import 'package:flutter_test/flutter_test.dart';

import 'package:local_config/src/core/model/key_namespace.dart';
import 'package:local_config/src/domain/policy/prune_policy.dart';
import 'package:local_config/src/domain/policy/composite_prune_policy.dart';

class FakePolicy implements KeyValuePrunePolicy {
  FakePolicy(this.result);

  final bool result;

  int calls = 0;

  @override
  bool shouldRemove({
    required KeyNamespace namespace,
    required MapEntry<String, String> entry,
    required Map<String, String> retained,
  }) {
    calls++;
    return result;
  }
}

void main() {
  final ns = KeyNamespace(base: 'cfg');
  const entry = MapEntry('cfg_a', '1');
  const retained = {'a': '1'};

  test('returns true when any policy returns true', () {
    final p1 = FakePolicy(false);
    final p2 = FakePolicy(true);
    final p3 = FakePolicy(false);

    final composite = CompositePrunePolicy(policies: [p1, p2, p3]);

    final result = composite.shouldRemove(
      namespace: ns,
      entry: entry,
      retained: retained,
    );

    expect(result, true);
  });

  test('returns false when all policies return false', () {
    final composite = CompositePrunePolicy(
      policies: [FakePolicy(false), FakePolicy(false)],
    );

    final result = composite.shouldRemove(
      namespace: ns,
      entry: entry,
      retained: retained,
    );

    expect(result, false);
  });

  test('short-circuits after first true', () {
    final p1 = FakePolicy(true);
    final p2 = FakePolicy(true);
    final p3 = FakePolicy(true);

    final composite = CompositePrunePolicy(policies: [p1, p2, p3]);

    composite.shouldRemove(namespace: ns, entry: entry, retained: retained);

    expect(p1.calls, 1);
    expect(p2.calls, 0);
    expect(p3.calls, 0);
  });

  test('evaluates all when none return true', () {
    final p1 = FakePolicy(false);
    final p2 = FakePolicy(false);

    final composite = CompositePrunePolicy(policies: [p1, p2]);

    composite.shouldRemove(namespace: ns, entry: entry, retained: retained);

    expect(p1.calls, 1);
    expect(p2.calls, 1);
  });

  test('returns false when policy list is empty', () {
    final composite = CompositePrunePolicy(policies: const []);

    final result = composite.shouldRemove(
      namespace: ns,
      entry: entry,
      retained: retained,
    );

    expect(result, false);
  });
}

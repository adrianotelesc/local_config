import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/core/model/key_namespace.dart';

void main() {
  group('KeyNamespace', () {
    group('construction', () {
      test('creates with base only', () {
        final namespace = KeyNamespace(base: 'app');

        expect(namespace.base, 'app');
        expect(namespace.segments, isEmpty);
        expect(namespace.basePrefix, 'app_');
        expect(namespace.qualifiedPrefix, 'app_');
      });

      test('creates with segments', () {
        final namespace = KeyNamespace(base: 'app', segments: ['user', 'v1']);

        expect(namespace.basePrefix, 'app_');
        expect(namespace.qualifiedPrefix, 'app_user_v1_');
      });

      test('segments list is unmodifiable', () {
        final namespace = KeyNamespace(base: 'app', segments: ['a']);

        expect(() => namespace.segments.add('b'), throwsUnsupportedError);
      });

      test('throws assertion when base is empty', () {
        expect(() => KeyNamespace(base: ''), throwsAssertionError);
      });

      test('throws assertion when a segment is empty', () {
        expect(
          () => KeyNamespace(base: 'app', segments: ['']),
          throwsAssertionError,
        );
      });
    });

    group('matches', () {
      final namespace = KeyNamespace(base: 'app', segments: ['user']);

      test('matchesBase detects base prefix', () {
        expect(namespace.matchesBase('app_key'), isTrue);
        expect(namespace.matchesBase('other_key'), isFalse);
      });

      test('matchesQualified detects qualified prefix', () {
        expect(namespace.matchesQualified('app_user_key'), isTrue);
        expect(namespace.matchesQualified('app_other_key'), isFalse);
      });
    });

    group('qualify', () {
      final namespace = KeyNamespace(base: 'app', segments: ['user']);

      test('qualifies plain key', () {
        expect(namespace.qualify('theme'), 'app_user_theme');
      });

      test('is idempotent for qualified key', () {
        const key = 'app_user_theme';

        expect(namespace.qualify(key), key);
      });

      test('upgrades base-qualified key', () {
        expect(namespace.qualify('app_theme'), 'app_user_theme');
      });

      test('throws on empty key', () {
        expect(() => namespace.qualify(''), throwsArgumentError);
      });

      test('throws when key equals qualified prefix', () {
        expect(() => namespace.qualify('app_user_'), throwsArgumentError);
      });

      test('throws when key equals base prefix', () {
        expect(() => namespace.qualify('app_'), throwsArgumentError);
      });
    });

    group('strip', () {
      final namespace = KeyNamespace(base: 'app', segments: ['user']);

      test('strips qualified prefix', () {
        expect(namespace.strip('app_user_theme'), 'theme');
      });

      test('strips base prefix', () {
        expect(namespace.strip('app_theme'), 'theme');
      });

      test('returns original when not matching', () {
        expect(namespace.strip('other_theme'), 'other_theme');
      });

      test('strip after qualify returns original leaf', () {
        const leaf = 'theme';
        final qualified = namespace.qualify(leaf);

        expect(namespace.strip(qualified), leaf);
      });
    });

    group('round-trip behavior', () {
      final namespace = KeyNamespace(base: 'cfg', segments: ['v1']);

      test('qualify → strip round trip', () {
        const leaf = 'enabled';

        final q = namespace.qualify(leaf);
        final s = namespace.strip(q);

        expect(s, leaf);
      });

      test('qualify is idempotent', () {
        final q1 = namespace.qualify('flag');
        final q2 = namespace.qualify(q1);

        expect(q1, q2);
      });
    });

    group('toString', () {
      test('returns qualified prefix', () {
        final namespace = KeyNamespace(base: 'app', segments: ['x']);

        expect(namespace.toString(), 'app_x_');
      });
    });

    group('equality', () {
      test('equal when base and segments equal', () {
        final a = KeyNamespace(base: 'app', segments: ['a']);
        final b = KeyNamespace(base: 'app', segments: ['a']);

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('not equal when base differs', () {
        final a = KeyNamespace(base: 'a');
        final b = KeyNamespace(base: 'b');

        expect(a, isNot(equals(b)));
      });

      test('not equal when segments differ', () {
        final a = KeyNamespace(base: 'app', segments: ['a']);
        final b = KeyNamespace(base: 'app', segments: ['b']);

        expect(a, isNot(equals(b)));
      });
    });
  });
}

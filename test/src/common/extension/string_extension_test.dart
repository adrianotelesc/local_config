import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/common/extension/string_extension.dart';

void main() {
  group('StringExtension.containsInsensitive', () {
    test('returns true for exact match', () {
      expect('hello'.containsInsensitive('hello'), isTrue);
    });

    test('returns true ignoring case', () {
      expect('Hello'.containsInsensitive('hello'), isTrue);
      expect('HELLO'.containsInsensitive('hello'), isTrue);
      expect('hello'.containsInsensitive('HELLO'), isTrue);
    });

    test('returns true for substring match', () {
      expect('Hello World'.containsInsensitive('world'), isTrue);
    });

    test('returns true for substring at start', () {
      expect('Flutter'.containsInsensitive('flu'), isTrue);
    });

    test('returns true for substring at end', () {
      expect('Flutter'.containsInsensitive('TER'), isTrue);
    });

    test('returns false when not contained', () {
      expect('hello'.containsInsensitive('xyz'), isFalse);
    });

    test('returns true when other is empty', () {
      // String.contains('') is always true
      expect('hello'.containsInsensitive(''), isTrue);
    });

    test('returns false when source is empty and other is not', () {
      expect(''.containsInsensitive('a'), isFalse);
    });

    test('returns true when both are empty', () {
      expect(''.containsInsensitive(''), isTrue);
    });

    test('works with spaces', () {
      expect('Hello Big World'.containsInsensitive('big world'), isTrue);
    });

    test('works with simple unicode case folding', () {
      expect('Árvore'.containsInsensitive('ár'), isTrue);
    });

    test('does not mutate original string behavior', () {
      final string = 'Hello';
      string.containsInsensitive('he');
      expect(string, 'Hello'); // sanity check
    });
  });
}

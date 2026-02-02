import 'package:flutter/foundation.dart';

class KeyNamespace {
  static const String separator = '.';

  final String _base;
  final List<String> _segments;

  late final String _basePrefix = '$_base$separator';

  late final String _qualifiedPrefix =
      [_base, ..._segments].join(separator) + separator;

  KeyNamespace({required String base, List<String> segments = const []})
    : assert(base.isNotEmpty, 'base cannot be empty'),
      assert(!base.contains(separator), 'base cannot contain separator'),
      assert(
        segments.every((p) => p.isNotEmpty),
        'segments cannot contain empty',
      ),
      assert(
        segments.every((p) => !p.contains(separator)),
        'segments cannot contain separator',
      ),
      _base = base,
      _segments = List.unmodifiable(segments);

  String get base => _base;

  List<String> get segments => _segments;

  String get basePrefix => _basePrefix;

  String get qualifiedPrefix => _qualifiedPrefix;

  String qualify(String value) => '$_qualifiedPrefix$value';

  bool matchesBase(String value) => value.startsWith(_basePrefix);

  bool matchesQualified(String value) => value.startsWith(_qualifiedPrefix);

  String strip(String value) => value.replaceFirst(_qualifiedPrefix, '');

  @override
  String toString() => _qualifiedPrefix;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KeyNamespace &&
          base == other.base &&
          listEquals(segments, other.segments);

  @override
  int get hashCode => Object.hash(base, Object.hashAll(segments));
}

import 'package:flutter/foundation.dart';

class KeyNamespace {
  static const String separator = '_';

  final String _base;

  final List<String> _segments;

  late final String _basePrefix = '$_base$separator';

  late final String _qualifiedPrefix =
      [_base, ..._segments].join(separator) + separator;

  KeyNamespace({required String base, List<String> segments = const []})
    : assert(base.isNotEmpty, 'base cannot be empty'),
      assert(
        segments.every((p) => p.isNotEmpty),
        'segments cannot contain empty',
      ),
      _base = base,
      _segments = List.unmodifiable(segments);

  String get base => _base;

  List<String> get segments => _segments;

  String get basePrefix => _basePrefix;

  String get qualifiedPrefix => _qualifiedPrefix;

  bool matchesBase(String key) => key.startsWith(_basePrefix);

  bool matchesQualified(String key) => key.startsWith(_qualifiedPrefix);

  String qualify(String key) {
    if (key.isEmpty) {
      throw ArgumentError.value(key, 'key must not be empty');
    }

    if (key == _qualifiedPrefix || key == _basePrefix) {
      throw ArgumentError.value(
        key,
        'key must include a leaf name after namespace',
      );
    }

    if (key.startsWith(_qualifiedPrefix)) {
      return key;
    }

    if (key.startsWith(_basePrefix)) {
      final rest = key.substring(_basePrefix.length);
      return '$_qualifiedPrefix$rest';
    }

    return '$_qualifiedPrefix$key';
  }

  String strip(String key) {
    if (matchesQualified(key)) return key.substring(_qualifiedPrefix.length);
    if (matchesBase(key)) return key.substring(_basePrefix.length);
    return key;
  }

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

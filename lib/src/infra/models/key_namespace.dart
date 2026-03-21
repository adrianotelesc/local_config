import 'package:flutter/foundation.dart';

class KeyNamespace {
  KeyNamespace({
    required String base,
    List<String> segments = const [],
  }) : assert(base.isNotEmpty, 'base cannot be empty'),
       assert(
         segments.every((p) => p.isNotEmpty),
         'segments cannot contain empty',
       ),
       _base = base,
       _segments = List.unmodifiable(segments);

  final String _base;

  final List<String> _segments;

  late final String _basePrefix = '$_base$separator';

  late final String _qualifiedPrefix =
      [_base, ..._segments].join(separator) + separator;

  static const String separator = '_';

  bool hasBasePrefix(String key) => key.startsWith(_basePrefix);

  bool hasQualifiedPrefix(String key) => key.startsWith(_qualifiedPrefix);

  String qualify(String key) {
    if (key.isEmpty) {
      throw ArgumentError.value(key, 'key', 'must not be empty');
    }

    if (key == _basePrefix || key == _qualifiedPrefix) {
      throw ArgumentError.value(
        key,
        'key',
        'must not be exactly the same as the namespace prefix to avoid ambiguity',
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
    if (hasQualifiedPrefix(key)) return key.substring(_qualifiedPrefix.length);
    if (hasBasePrefix(key)) return key.substring(_basePrefix.length);
    return key;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KeyNamespace &&
          _base == other._base &&
          listEquals(_segments, other._segments);

  @override
  int get hashCode => Object.hash(_base, Object.hashAll(_segments));
}

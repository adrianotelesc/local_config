class KeyNamespace {
  final String _base;
  final List<String> _segments;
  final String _separator;

  late final String _basePrefix = '$_base$_separator';

  late final String _qualifiedPrefix =
      [_base, ..._segments].join(_separator) + _separator;

  KeyNamespace({
    required String base,
    List<String> segments = const [],
    String separator = '::',
  }) : assert(base.isNotEmpty, 'base cannot be empty'),
       assert(separator.isNotEmpty, 'separator cannot be empty'),
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
       _segments = List.unmodifiable(segments),
       _separator = separator;

  String get base => _base;

  String get separator => _separator;

  List<String> get segments => _segments;

  String get basePrefix => _basePrefix;

  String get qualifiedPrefix => _qualifiedPrefix;

  String qualify(String value) => '$_qualifiedPrefix$value';

  bool matchesBase(String value) => value.startsWith(_basePrefix);

  bool matchesQualified(String value) => value.startsWith(_qualifiedPrefix);

  String strip(String value) {
    if (!matchesQualified(value)) return value;
    return value.substring(_qualifiedPrefix.length);
  }

  @override
  String toString() => _qualifiedPrefix;
}

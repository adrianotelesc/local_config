class KeyNamespace {
  final String _namespace;

  final String _separator;

  KeyNamespace({
    required String namespace,
    String separator = ':',
  }) : assert(namespace.isNotEmpty, 'namespace cannot be empty'),
       assert(separator.isNotEmpty, 'separator cannot be empty'),
       _namespace = namespace,
       _separator = separator;

  get _keyPrefix => '$_namespace$_separator';

  String apply(String key) => '$_keyPrefix$key';

  bool matches(String key) => key.startsWith(_keyPrefix);

  String strip(String key) => key.replaceFirst(_keyPrefix, '');
}

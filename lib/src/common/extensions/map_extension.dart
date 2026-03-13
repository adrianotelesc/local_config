extension MapExtension<K, V> on Map<K, V> {
  Map<K, V> where(bool Function(K, V) test) => Map<K, V>.fromEntries(
    entries.where((entry) => test(entry.key, entry.value)),
  );

  Map<K, V> whereKey(bool Function(K) test) =>
      Map<K, V>.fromEntries(entries.where((entry) => test(entry.key)));

  List<(K, V)> toRecordList() =>
      entries.map((entry) => (entry.key, entry.value)).toList();

  bool anyValue(bool Function(V) test) => values.any((value) => test(value));

  Map<K, V2> mapValues<V2>(V2 Function(V) convert) =>
      map((key, value) => MapEntry(key, convert(value)));

  Map<K2, V> mapKeys<K2>(K2 Function(K) convert) =>
      map((key, value) => MapEntry(convert(key), value));
}

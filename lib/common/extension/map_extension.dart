extension MapExtension<K, V> on Map<K, V> {
  Map<K, V> whereKey(bool Function(K) test) {
    return Map<K, V>.fromEntries(entries.where((entry) => test(entry.key)));
  }

  List<(K, V)> get records {
    return entries.map((entry) => (entry.key, entry.value)).toList();
  }

  bool anyValue(bool Function(V) test) {
    return values.any((value) => test(value));
  }
}

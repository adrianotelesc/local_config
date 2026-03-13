extension StringExtension on String {
  bool containsInsensitive(String other) =>
      toLowerCase().contains(other.toLowerCase());
}

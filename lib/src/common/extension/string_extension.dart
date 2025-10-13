import 'dart:convert';

extension StringExtension on String {
  Map<String, dynamic>? get asMapOrNull {
    try {
      return jsonDecode(this);
    } catch (_) {
      return null;
    }
  }

  bool? get asBoolOrNull => bool.tryParse(this);

  double? get asDoubleOrNull => double.tryParse(this);

  int? get asIntOrNull => int.tryParse(this);

  bool containsInsensitive(String other) =>
      toLowerCase().contains(other.toLowerCase());
}

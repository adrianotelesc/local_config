import 'dart:convert';

extension StringExtension on String {
  Map<String, dynamic>? get asJson {
    try {
      return jsonDecode(this);
    } catch (_) {
      return null;
    }
  }

  bool? get asBool => bool.tryParse(this);

  double? get asDouble => double.tryParse(this);

  int? get asInt => int.tryParse(this);

  bool containsInsensitive(String substring) {
    return toLowerCase().contains(substring.toLowerCase());
  }
}

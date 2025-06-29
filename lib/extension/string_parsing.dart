import 'dart:convert';

extension StringParsing on String {
  Map<String, dynamic>? get asJson {
    try {
      return jsonDecode(this);
    } catch (e) {
      return null;
    }
  }

  bool? get asBool => bool.tryParse(this);

  double? get asDouble => double.tryParse(this);

  int? get asInt => int.tryParse(this);
}

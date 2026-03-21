import 'dart:convert';

String stringify(Object object) {
  if (object is String) return object;

  if (object is Map || object is List) {
    return tryJsonEncode(object) ?? object.toString();
  }

  return object.toString();
}

bool? tryParseBool(Object object) {
  if (object is bool) return object;

  if (object is num) {
    return switch (object) {
      1 => true,
      0 => false,
      _ => null,
    };
  }

  if (object is String) {
    final s = object.trim().toLowerCase();
    return switch (s) {
      '0' => false,
      '1' => true,
      _ => bool.tryParse(s),
    };
  }

  return null;
}

Object? tryJsonDecode(String source) {
  try {
    return jsonDecode(source);
  } catch (_) {
    return null;
  }
}

String? tryJsonEncode(Object object) {
  try {
    return jsonEncode(object);
  } catch (_) {
    return null;
  }
}

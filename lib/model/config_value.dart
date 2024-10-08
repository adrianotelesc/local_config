enum ConfigValueType {
  bool,
  int,
  double,
  string,
  json;
}

class ConfigValue {
  final String value;
  final ConfigValueType valueType;

  const ConfigValue({
    required this.value,
    required this.valueType,
  });

  bool get isNumeric =>
      valueType == ConfigValueType.int || valueType == ConfigValueType.double;

  bool? asBool() => bool.tryParse(value);

  double? asDouble() => double.tryParse(value);

  int? asInt() => int.tryParse(value);

  String? asString() => value;
}

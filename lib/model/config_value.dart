import 'package:local_config/extension/string_parsing.dart';

class ConfigValue {
  final String _value;
  final ConfigValueType type;

  bool? get asBool => _value.asBool;
  double? get asDouble => _value.asDouble;
  int? get asInt => _value.asInt;
  Map<String, dynamic>? get asJson => _value.asJson;
  String get asString => _value;

  ConfigValue(String value)
      : _value = value,
        type = _inferType(value);

  static _inferType(String value) {
    if (value.asBool != null) return ConfigValueType.boolean;
    if (value.asInt != null) return ConfigValueType.integer;
    if (value.asDouble != null) return ConfigValueType.decimal;
    if (value.asJson != null) return ConfigValueType.json;
    return ConfigValueType.string;
  }
}

enum ConfigValueType {
  boolean,
  integer,
  decimal,
  string,
  json;

  bool get isText =>
      this == ConfigValueType.string || this == ConfigValueType.json;
}

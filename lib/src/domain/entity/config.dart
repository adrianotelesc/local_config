import 'package:local_config/src/common/util/json_safe_convert.dart';

class ConfigValue {
  final String defaultValue;

  final String? overriddenValue;

  const ConfigValue({required this.defaultValue, this.overriddenValue});

  @override
  int get hashCode => Object.hash(defaultValue, overriddenValue);

  bool get isDefault =>
      overriddenValue == null || overriddenValue == defaultValue;

  bool get isOverridden =>
      overriddenValue != null && overriddenValue != defaultValue;

  ConfigType get type => ConfigType.inferFromValue(defaultValue);

  String get raw => overriddenValue ?? defaultValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigValue &&
          defaultValue == other.defaultValue &&
          overriddenValue == other.overriddenValue;

  ConfigValue copyWith({String? overriddenValue}) {
    return ConfigValue(
      defaultValue: defaultValue,
      overriddenValue: overriddenValue,
    );
  }

  @override
  String toString() =>
      'ConfigValue(default: $defaultValue, overridden: $overriddenValue)';
}

enum ConfigType {
  boolean,
  number,
  string,
  json;

  bool get isText => this == ConfigType.string || this == ConfigType.json;

  static ConfigType inferFromValue(String source) {
    if (bool.tryParse(source) != null) return ConfigType.boolean;
    if (num.tryParse(source) != null) return ConfigType.number;
    if (tryJsonDecode(source) != null) return ConfigType.json;
    return ConfigType.string;
  }
}

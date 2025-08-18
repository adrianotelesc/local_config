import 'package:local_config/extension/string_extension.dart';

class Config {
  final String defaultValue;

  final String? overriddenValue;

  String get value => overriddenValue ?? defaultValue;

  bool get isDefault =>
      overriddenValue == null || overriddenValue == defaultValue;

  bool get isOverridden =>
      overriddenValue != null && overriddenValue != defaultValue;

  ConfigType get type {
    if (defaultValue.asBool != null) return ConfigType.boolean;
    if (defaultValue.asDouble != null) return ConfigType.number;
    if (defaultValue.asJson != null) return ConfigType.json;
    return ConfigType.string;
  }

  const Config({
    required this.defaultValue,
    this.overriddenValue,
  });

  Config copyWith({
    String? overriddenValue,
  }) {
    return Config(
      defaultValue: defaultValue,
      overriddenValue: overriddenValue,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Config &&
          defaultValue == other.defaultValue &&
          overriddenValue == other.overriddenValue;

  @override
  int get hashCode => Object.hash(defaultValue, overriddenValue);

  @override
  String toString() =>
      'Config(default: $defaultValue, overridden: $overriddenValue)';
}

enum ConfigType {
  boolean,
  number,
  string,
  json;

  bool get isText => this == ConfigType.string || this == ConfigType.json;
}

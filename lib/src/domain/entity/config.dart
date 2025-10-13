import 'package:local_config/src/common/extension/string_extension.dart';

class Config {
  final String defaultValue;

  final String? overriddenValue;

  const Config({
    required this.defaultValue,
    this.overriddenValue,
  });

  @override
  int get hashCode => Object.hash(defaultValue, overriddenValue);

  bool get isDefault =>
      overriddenValue == null || overriddenValue == defaultValue;

  bool get isOverridden =>
      overriddenValue != null && overriddenValue != defaultValue;

  ConfigType get type {
    if (defaultValue.asBoolOrNull != null) return ConfigType.boolean;
    if (defaultValue.asDoubleOrNull != null) return ConfigType.number;
    if (defaultValue.asMapOrNull != null) return ConfigType.json;
    return ConfigType.string;
  }

  String get value => overriddenValue ?? defaultValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Config &&
          defaultValue == other.defaultValue &&
          overriddenValue == other.overriddenValue;

  Config copyWith({
    String? overriddenValue,
  }) {
    return Config(
      defaultValue: defaultValue,
      overriddenValue: overriddenValue,
    );
  }

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

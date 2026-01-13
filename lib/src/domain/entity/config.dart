import 'package:local_config/src/common/extension/string_extension.dart';

class ConfigValue {
  final dynamic defaultValue;

  final dynamic overriddenValue;

  const ConfigValue({required this.defaultValue, this.overriddenValue});

  @override
  int get hashCode => Object.hash(defaultValue, overriddenValue);

  bool get isDefault =>
      overriddenValue == null || overriddenValue == defaultValue;

  bool get isOverridden =>
      overriddenValue != null && overriddenValue != defaultValue;

  ConfigType get type {
    return switch (defaultValue) {
      bool() => ConfigType.boolean,
      num() => ConfigType.number,
      Map() => ConfigType.json,
      String() => _inferTypeFromString(defaultValue),
      _ => throw Exception('Unsupported type: ${defaultValue.runtimeType}'),
    };
  }

  ConfigType _inferTypeFromString(String value) {
    if (value.asBoolOrNull != null) return ConfigType.boolean;
    if (value.asDoubleOrNull != null) return ConfigType.number;
    if (value.asMapOrNull != null) return ConfigType.json;
    return ConfigType.string;
  }

  dynamic get value => overriddenValue ?? defaultValue;

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
}

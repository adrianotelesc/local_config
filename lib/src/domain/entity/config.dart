import 'package:local_config/src/common/extension/string_extension.dart';

class LocalConfigValue {
  final dynamic defaultValue;

  final dynamic overriddenValue;

  const LocalConfigValue({required this.defaultValue, this.overriddenValue});

  @override
  int get hashCode => Object.hash(defaultValue, overriddenValue);

  bool get isDefault =>
      overriddenValue == null || overriddenValue == defaultValue;

  bool get isOverridden =>
      overriddenValue != null && overriddenValue != defaultValue;

  LocalConfigType get type {
    return switch (defaultValue) {
      bool() => LocalConfigType.boolean,
      num() => LocalConfigType.number,
      Map() => LocalConfigType.json,
      String() => _inferTypeFromString(defaultValue),
      _ => throw Exception('Unsupported type: ${defaultValue.runtimeType}'),
    };
  }

  LocalConfigType _inferTypeFromString(String value) {
    if (value.asBoolOrNull != null) return LocalConfigType.boolean;
    if (value.asDoubleOrNull != null) return LocalConfigType.number;
    if (value.asMapOrNull != null) return LocalConfigType.json;
    return LocalConfigType.string;
  }

  dynamic get value => overriddenValue ?? defaultValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalConfigValue &&
          defaultValue == other.defaultValue &&
          overriddenValue == other.overriddenValue;

  LocalConfigValue copyWith({String? overriddenValue}) {
    return LocalConfigValue(
      defaultValue: defaultValue,
      overriddenValue: overriddenValue,
    );
  }

  @override
  String toString() =>
      'LocalConfigValue(default: $defaultValue, overridden: $overriddenValue)';
}

enum LocalConfigType {
  boolean,
  number,
  string,
  json;

  bool get isText =>
      this == LocalConfigType.string || this == LocalConfigType.json;
}

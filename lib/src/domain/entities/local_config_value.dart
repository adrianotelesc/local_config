import 'package:local_config/src/common/utils/type_converters.dart';

/// Encapsulates the value of a Local Config parameter.
class LocalConfigValue {
  /// Wraps a value with metadata and type-safe getters.
  LocalConfigValue({
    required this.type,
    required this.defaultValue,
    this.overrideValue,
  }) : assert(
         type == LocalConfigType.infer(defaultValue),
         'default value type must match the inferred type.',
       ),
       assert(
         overrideValue == null || type == LocalConfigType.infer(overrideValue),
         'override value type must match the inferred type.',
       );

  /// The type of the value.
  final LocalConfigType type;

  /// The default value.
  final String defaultValue;

  /// The override value.
  final String? overrideValue;

  /// Returns true if the override value is not set or is the same as the default value.
  bool get isDefault => overrideValue == null || overrideValue == defaultValue;

  /// Returns true if the override value is set and different from the default value.
  bool get hasOverride =>
      overrideValue != null && overrideValue != defaultValue;

  /// Returns the value as a String, preferring the override if it exists.
  String get asString => overrideValue ?? defaultValue;

  /// Returns the value as a bool if possible, otherwise null.
  bool? get asBool => tryParseBool(asString);

  /// Returns the value as a double if possible, otherwise null.
  double? get asDouble => double.tryParse(asString);

  /// Returns the value as an int if possible, otherwise null.
  int? get asInt => int.tryParse(asString);

  /// Returns the value as a JSON-decoded object if possible, otherwise null.
  Object? get asJson => tryJsonDecode(asString);

  /// Returns a copy of this LocalConfigValue with the override value.
  LocalConfigValue withOverride(String? value) => LocalConfigValue(
    type: type,
    defaultValue: defaultValue,
    overrideValue: value,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalConfigValue &&
          type == other.type &&
          defaultValue == other.defaultValue &&
          overrideValue == other.overrideValue;

  @override
  int get hashCode => Object.hash(type, defaultValue, overrideValue);
}

enum LocalConfigType {
  boolean,
  number,
  string,
  json;

  static LocalConfigType infer(String source) {
    if (tryParseBool(source) != null) return LocalConfigType.boolean;
    if (num.tryParse(source) != null) return LocalConfigType.number;
    if (tryJsonDecode(source) != null) return LocalConfigType.json;
    return LocalConfigType.string;
  }

  bool get isTextBased =>
      this == LocalConfigType.string || this == LocalConfigType.json;
}

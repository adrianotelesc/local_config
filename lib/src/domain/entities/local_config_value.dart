import 'package:flutter/foundation.dart';
import 'package:local_config/src/common/utils/type_converters.dart';

/// Encapsulates the value of a Local Config parameter.
class LocalConfigValue {
  /// Wraps a value with metadata and type-safe getters.
  @protected
  LocalConfigValue({
    required String value,
    required this.source,
  }) : _value = value;

  /// The default value.
  final String _value;

  /// Indicates at which source this value came from.
  final ValueSource source;

  /// Returns the value as a String, preferring the override if it exists.
  String get asString => _value;

  /// Returns the value as a bool if possible, otherwise null.
  bool? get asBool => tryParseBool(asString);

  /// Returns the value as a double if possible, otherwise null.
  double? get asDouble => double.tryParse(asString);

  /// Returns the value as an int if possible, otherwise null.
  int? get asInt => int.tryParse(asString);

  /// Returns the value as a JSON-decoded object if possible, otherwise null.
  Object? get asJson => tryJsonDecode(asString);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalConfigValue &&
          _value == other._value &&
          source == other.source;

  @override
  int get hashCode => Object.hash(source, _value);

  @override
  String toString() => asString;
}

enum ValueSource {
  /// The value was defined by default config.
  valueDefault,

  /// The value was defined by local config.
  valueLocal,
}

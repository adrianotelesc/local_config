import 'package:flutter/material.dart';
import 'package:local_config/src/common/utils/type_converters.dart';
import 'package:local_config/src/presentation/l10n/generated/local_config_localizations.dart';
import 'package:local_config/src/presentation/local_config_theme.dart';
import 'package:local_config/src/presentation/widgets/text_editor/controller/json_editor_controller.dart';
import 'package:local_config/src/presentation/widgets/text_editor/controller/string_editor_controller.dart';
import 'package:local_config/src/presentation/widgets/text_editor/controller/text_editor_controller.dart';

final class ConfigValue {
  final ConfigValueType type;

  final String defaultValue;

  final String? overrideValue;

  ConfigValue({
    required this.type,
    required this.defaultValue,
    required this.overrideValue,
  }) : assert(
         type == ConfigValueType.fromValue(defaultValue),
         'value type must match the inferred type.',
       ),
       assert(
         overrideValue == null ||
             type == ConfigValueType.fromValue(overrideValue),
         'value type must match the inferred type.',
       );

  String get effectiveValue => overrideValue ?? defaultValue;

  bool get hasOverride =>
      overrideValue != null && overrideValue != defaultValue;

  String getLocalDisplayText(final BuildContext context) {
    return type == ConfigValueType.string && overrideValue?.isEmpty == true
        ? LocalConfigLocalizations.of(context)!.emptyString
        : overrideValue ?? '';
  }

  String getDefaultDisplayText(final BuildContext context) {
    return type == ConfigValueType.string && defaultValue.isEmpty
        ? LocalConfigLocalizations.of(context)!.emptyString
        : defaultValue;
  }

  ConfigValue copyWith({final String? overrideValue}) {
    return ConfigValue(
      type: type,
      defaultValue: defaultValue,
      overrideValue: overrideValue,
    );
  }

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is ConfigValue &&
          type == other.type &&
          defaultValue == other.defaultValue &&
          overrideValue == other.overrideValue;

  @override
  int get hashCode => Object.hash(type, defaultValue, overrideValue);

  @override
  String toString() => effectiveValue;
}

enum ConfigValueType {
  boolean,
  number,
  string,
  json;

  static ConfigValueType fromValue(final String value) {
    if (num.tryParse(value) != null) return ConfigValueType.number;
    if (tryParseBool(value) != null) return ConfigValueType.boolean;
    if (tryJsonDecode(value) != null) return ConfigValueType.json;
    return ConfigValueType.string;
  }

  bool get isTextBased =>
      this == ConfigValueType.string || this == ConfigValueType.json;

  List<String> get allowedValues =>
      this == ConfigValueType.boolean ? ['false', 'true'] : [];

  IconData get displayIcon => switch (this) {
    ConfigValueType.boolean => Icons.toggle_on,
    ConfigValueType.number => Icons.onetwothree,
    ConfigValueType.string => Icons.abc,
    ConfigValueType.json => Icons.data_object,
  };

  String getDisplayName(final BuildContext context) => switch (this) {
    ConfigValueType.boolean => LocalConfigLocalizations.of(context)!.boolean,
    ConfigValueType.number => LocalConfigLocalizations.of(context)!.number,
    ConfigValueType.string => 'String',
    ConfigValueType.json => 'JSON',
  };

  TextSpan usageHint(
    final BuildContext context, {
    final String name = 'name',
  }) {
    final getterNameSuffixes = switch (this) {
      ConfigValueType.boolean => ['Boolean'],
      ConfigValueType.number => ['Int', 'Double'],
      ConfigValueType.string || ConfigValueType.json => ['String'],
    };

    return TextSpan(
      children: [
        TextSpan(text: LocalConfigLocalizations.of(context)!.help),
        ...getterNameSuffixes.map((suffix) {
          return TextSpan(
            children: [
              TextSpan(
                text: '\nconfig.get$suffix("',
                style: context.extendedTextTheme.codeBodyMedium?.copyWith(
                  color: ColorScheme.of(context).surface,
                ),
              ),
              TextSpan(
                text: name,
                style: context.extendedTextTheme.codeBodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorScheme.of(context).surface,
                ),
              ),
              TextSpan(
                text: '");',
                style: context.extendedTextTheme.codeBodyMedium?.copyWith(
                  color: ColorScheme.of(context).surface,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  String? validator(
    final BuildContext context,
    final String value,
  ) => switch (this) {
    ConfigValueType.boolean when tryParseBool(value) == null =>
      LocalConfigLocalizations.of(context)!.invalidBoolean,
    ConfigValueType.number when num.tryParse(value) == null =>
      LocalConfigLocalizations.of(context)!.invalidNumber,
    ConfigValueType.json when tryJsonDecode(value) == null =>
      LocalConfigLocalizations.of(context)!.invalidJson,
    _ => null,
  };

  // TODO: Refactor this.
  TextEditorController get textEditorController {
    return switch (this) {
      ConfigValueType.json => JsonEditorController(),
      _ => StringEditorController(),
    };
  }
}

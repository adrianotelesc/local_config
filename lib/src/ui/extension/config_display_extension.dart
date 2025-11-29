import 'package:flutter/material.dart';
import 'package:local_config/src/ui/l10n/local_config_localizations.dart';
import 'package:local_config/src/ui/widget/text_editor/controller/text_editor_controller.dart';
import 'package:local_config/src/ui/widget/text_editor/controller/json_editor_controller.dart';
import 'package:local_config/src/ui/widget/text_editor/controller/string_editor_controller.dart';
import 'package:local_config/src/common/extension/string_extension.dart';
import 'package:local_config/src/domain/entity/config.dart';

extension ConfigDisplayExtension on LocalConfigValue {
  String getDisplayText(BuildContext context) {
    return type == LocalConfigType.string && value.isEmpty
        ? LocalConfigLocalizations.of(context)!.emptyString
        : value.toString();
  }
}

extension ConfigTypeExtension on LocalConfigType {
  List<String> get presets {
    return this == LocalConfigType.boolean ? ['false', 'true'] : [];
  }

  String getDisplayName(BuildContext context) {
    return switch (this) {
      LocalConfigType.boolean => LocalConfigLocalizations.of(context)!.boolean,
      LocalConfigType.number => LocalConfigLocalizations.of(context)!.number,
      LocalConfigType.string => 'String',
      LocalConfigType.json => 'JSON',
    };
  }

  IconData get icon {
    return switch (this) {
      LocalConfigType.boolean => Icons.toggle_on,
      LocalConfigType.number => Icons.onetwothree,
      LocalConfigType.string => Icons.abc,
      LocalConfigType.json => Icons.data_object,
    };
  }

  String? validator(BuildContext context, String? value) {
    if (this == LocalConfigType.boolean && value?.asBoolOrNull == null) {
      return LocalConfigLocalizations.of(context)!.invalidBoolean;
    }
    if (this == LocalConfigType.number && value?.asDoubleOrNull == null) {
      return LocalConfigLocalizations.of(context)!.invalidNumber;
    }
    if (this == LocalConfigType.json && value?.asMapOrNull == null) {
      return LocalConfigLocalizations.of(context)!.invalidJson;
    }
    return null;
  }

  // TODO: Refactor this.
  TextEditorController get textEditorController {
    return switch (this) {
      LocalConfigType.json => JsonEditorController(),
      _ => StringEditorController(),
    };
  }

  TextSpan help(BuildContext context, {String name = 'name'}) {
    final suffixes = switch (this) {
      LocalConfigType.boolean => ['Boolean'],
      LocalConfigType.number => ['Int', 'Double'],
      LocalConfigType.string || LocalConfigType.json => ['String'],
    };

    return TextSpan(
      children: [
        TextSpan(text: LocalConfigLocalizations.of(context)!.help),
        ...suffixes.map((suffix) {
          return TextSpan(
            children: [
              TextSpan(
                text: '\nconfig.get$suffix("',
                style: const TextStyle(fontFamily: 'monospace'),
              ),
              TextSpan(
                text: name,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(
                text: '");',
                style: TextStyle(fontFamily: 'monospace'),
              ),
            ],
          );
        }),
      ],
    );
  }
}

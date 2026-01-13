import 'package:flutter/material.dart';
import 'package:local_config/src/ui/l10n/local_config_localizations.dart';
import 'package:local_config/src/ui/widget/text_editor/controller/text_editor_controller.dart';
import 'package:local_config/src/ui/widget/text_editor/controller/json_editor_controller.dart';
import 'package:local_config/src/ui/widget/text_editor/controller/string_editor_controller.dart';
import 'package:local_config/src/common/extension/string_extension.dart';
import 'package:local_config/src/domain/entity/config.dart';

extension ConfigDisplayExtension on ConfigValue {
  String getDisplayText(BuildContext context) {
    return type == ConfigType.string && value.isEmpty
        ? LocalConfigLocalizations.of(context)!.emptyString
        : value.toString();
  }
}

extension ConfigTypeExtension on ConfigType {
  List<String> get presets {
    return this == ConfigType.boolean ? ['false', 'true'] : [];
  }

  String getDisplayName(BuildContext context) {
    return switch (this) {
      ConfigType.boolean => LocalConfigLocalizations.of(context)!.boolean,
      ConfigType.number => LocalConfigLocalizations.of(context)!.number,
      ConfigType.string => 'String',
      ConfigType.json => 'JSON',
    };
  }

  IconData get icon {
    return switch (this) {
      ConfigType.boolean => Icons.toggle_on,
      ConfigType.number => Icons.onetwothree,
      ConfigType.string => Icons.abc,
      ConfigType.json => Icons.data_object,
    };
  }

  String? validator(BuildContext context, String? value) {
    if (this == ConfigType.boolean && value?.asBoolOrNull == null) {
      return LocalConfigLocalizations.of(context)!.invalidBoolean;
    }
    if (this == ConfigType.number && value?.asDoubleOrNull == null) {
      return LocalConfigLocalizations.of(context)!.invalidNumber;
    }
    if (this == ConfigType.json && value?.asMapOrNull == null) {
      return LocalConfigLocalizations.of(context)!.invalidJson;
    }
    return null;
  }

  // TODO: Refactor this.
  TextEditorController get textEditorController {
    return switch (this) {
      ConfigType.json => JsonEditorController(),
      _ => StringEditorController(),
    };
  }

  TextSpan help(BuildContext context, {String name = 'name'}) {
    final suffixes = switch (this) {
      ConfigType.boolean => ['Boolean'],
      ConfigType.number => ['Int', 'Double'],
      ConfigType.string || ConfigType.json => ['String'],
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

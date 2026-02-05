import 'package:flutter/material.dart';
import 'package:local_config/src/common/util/json_safe_convert.dart';
import 'package:local_config/src/ui/l10n/local_config_localizations.dart';
import 'package:local_config/src/ui/widget/text_editor/controller/text_editor_controller.dart';
import 'package:local_config/src/ui/widget/text_editor/controller/json_editor_controller.dart';
import 'package:local_config/src/ui/widget/text_editor/controller/string_editor_controller.dart';
import 'package:local_config/src/domain/entity/config.dart';

extension ConfigDisplayExtension on ConfigValue {
  String getDisplayText(BuildContext context) {
    return type == ConfigType.string && raw.isEmpty
        ? LocalConfigLocalizations.of(context).emptyString
        : raw.toString();
  }
}

extension ConfigTypeExtension on ConfigType {
  List<String> get presets {
    return this == ConfigType.boolean ? ['false', 'true'] : [];
  }

  String getDisplayName(BuildContext context) {
    return switch (this) {
      ConfigType.boolean => LocalConfigLocalizations.of(context).boolean,
      ConfigType.number => LocalConfigLocalizations.of(context).number,
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

  String? validator(BuildContext context, String value) {
    if (this == ConfigType.boolean && bool.tryParse(value) == null) {
      return LocalConfigLocalizations.of(context).invalidBoolean;
    }
    if (this == ConfigType.number && num.tryParse(value) == null) {
      return LocalConfigLocalizations.of(context).invalidNumber;
    }
    if (this == ConfigType.json && tryJsonDecode(value) == null) {
      return LocalConfigLocalizations.of(context).invalidJson;
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
        TextSpan(text: LocalConfigLocalizations.of(context).help),
        ...suffixes.map((suffix) {
          return TextSpan(
            children: [
              TextSpan(
                text: '\nconfig.get$suffix("',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'GoogleSansCode',
                  color: ColorScheme.of(context).surface,
                ),
              ),
              TextSpan(
                text: name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'GoogleSansCode',
                  fontWeight: FontWeight.bold,
                  color: ColorScheme.of(context).surface,
                ),
              ),
              TextSpan(
                text: '");',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'GoogleSansCode',
                  color: ColorScheme.of(context).surface,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:local_config/ui/widget/text_editor/controller/text_editor_controller.dart';
import 'package:local_config/ui/widget/text_editor/controller/json_editor_controller.dart';
import 'package:local_config/ui/widget/text_editor/controller/string_editor_controller.dart';
import 'package:local_config/common/extension/string_extension.dart';
import 'package:local_config/domain/model/config.dart';

extension ConfigExtension on Config {
  String get displayText {
    return type == ConfigType.string && value.isEmpty
        ? '(empty string)'
        : value;
  }
}

extension ConfigTypeExtension on ConfigType {
  List<String> get presets {
    return this == ConfigType.boolean ? ['false', 'true'] : [];
  }

  String get displayName {
    return switch (this) {
      ConfigType.boolean => 'Boolean',
      ConfigType.number => 'Number',
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

  String? validator(String? value) {
    if (this == ConfigType.boolean && value?.asBool == null) {
      return 'Invalid bolean';
    }
    if (this == ConfigType.number && value?.asDouble == null) {
      return 'Invalid number';
    }
    if (this == ConfigType.json && value?.asJson == null) {
      return 'Invalid JSON';
    }
    return null;
  }

  TextEditorController get textEditorController {
    return switch (this) {
      ConfigType.json => JsonEditorController(),
      _ => StringEditorController(),
    };
  }

  TextSpan help({String name = 'name'}) {
    final suffixes = switch (this) {
      ConfigType.boolean => ['Boolean'],
      ConfigType.number => ['Int', 'Double'],
      ConfigType.string || ConfigType.json => ['String'],
    };

    return TextSpan(
      children: [
        const TextSpan(
          text:
              "This is the key you'll pass to the Local Config SDK,\nfor example:\n",
        ),
        ...suffixes.map((suffix) {
          return TextSpan(
            children: [
              TextSpan(
                text: '\nconfig.get$suffix("',
                style: const TextStyle(
                  fontFamily: 'monospace',
                ),
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
                style: TextStyle(
                  fontFamily: 'monospace',
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

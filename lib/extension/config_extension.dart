import 'package:flutter/material.dart';
import 'package:local_config/ui/screen/text_editor/controller/text_editor_controller.dart';
import 'package:local_config/ui/screen/text_editor/controller/json_editor_controller.dart';
import 'package:local_config/ui/screen/text_editor/controller/string_editor_controller.dart';
import 'package:local_config/extension/string_extension.dart';
import 'package:local_config/model/config.dart';

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
      ConfigType.json => Icons.data_object
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
}

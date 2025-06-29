import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:local_config/delegate/editor_delegate.dart';
import 'package:local_config/delegate/json_editor_delegate.dart';
import 'package:local_config/delegate/string_editor_delegate.dart';
import 'package:local_config/model/config_value.dart';

extension ConfigValueTypeExtension on ConfigValueType {
  List<String> get presetValues {
    switch (this) {
      case ConfigValueType.boolean:
        return ['false', 'true'];
      default:
        return [];
    }
  }

  String get name {
    switch (this) {
      case ConfigValueType.boolean:
        return 'bool';
      case ConfigValueType.integer:
        return 'int';
      case ConfigValueType.decimal:
        return 'double';
      case ConfigValueType.string:
        return 'String';
      case ConfigValueType.json:
        return 'JSON';
    }
  }

  IconData get icon {
    switch (this) {
      case ConfigValueType.boolean:
        return Icons.toggle_on;
      case ConfigValueType.integer:
      case ConfigValueType.decimal:
        return Icons.onetwothree;
      case ConfigValueType.string:
        return Icons.abc;
      case ConfigValueType.json:
        return Icons.data_object;
    }
  }

  String? validator(String? value) {
    value = value ?? '';
    switch (this) {
      case ConfigValueType.boolean:
        if (bool.tryParse(value) == null) {
          return 'Invalid bolean';
        }
        break;
      case ConfigValueType.integer:
        if (int.tryParse(value) == null) {
          return 'Invalid int';
        }
        break;
      case ConfigValueType.decimal:
        if (double.tryParse(value) == null) {
          return 'Invalid double';
        }
        break;
      case ConfigValueType.json:
        try {
          jsonDecode(value);
        } on FormatException {
          return 'Invalid JSON';
        }
        break;
      case ConfigValueType.string:
        break;
    }
    return null;
  }

  EditorDelegate get editorDelegate {
    switch (this) {
      case ConfigValueType.json:
        return JsonEditorDelegate();
      default:
        return StringDelegate();
    }
  }
}

extension ConfigValueExtension on ConfigValue {
  String get displayText {
    switch (type) {
      case ConfigValueType.string:
        return asString.isNotEmpty ? asString : '(empty string)';
      default:
        return asString;
    }
  }
}

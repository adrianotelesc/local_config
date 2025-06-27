import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:local_config/delegate/editor_delegate.dart';
import 'package:local_config/delegate/json_editor_delegate.dart';
import 'package:local_config/delegate/string_editor_delegate.dart';
import 'package:local_config/model/config_value.dart';

extension ConfigValueTypeExtension on ConfigValueType {
  List<String> get presetValues {
    switch (this) {
      case ConfigValueType.boolType:
        return ['false', 'true'];
      default:
        return [];
    }
  }

  String get name {
    switch (this) {
      case ConfigValueType.boolType:
        return 'bool';
      case ConfigValueType.intType:
        return 'int';
      case ConfigValueType.doubleType:
        return 'double';
      case ConfigValueType.stringType:
        return 'String';
      case ConfigValueType.jsonType:
        return 'JSON';
    }
  }

  IconData get icon {
    switch (this) {
      case ConfigValueType.boolType:
        return Icons.toggle_on;
      case ConfigValueType.intType:
      case ConfigValueType.doubleType:
        return Icons.onetwothree;
      case ConfigValueType.stringType:
        return Icons.abc;
      case ConfigValueType.jsonType:
        return Icons.data_object;
    }
  }

  String? validator(String? value) {
    value = value ?? '';
    switch (this) {
      case ConfigValueType.boolType:
        if (bool.tryParse(value) == null) {
          return 'Invalid bolean';
        }
        break;
      case ConfigValueType.intType:
        if (int.tryParse(value) == null) {
          return 'Invalid int';
        }
        break;
      case ConfigValueType.doubleType:
        if (double.tryParse(value) == null) {
          return 'Invalid double';
        }
        break;
      case ConfigValueType.jsonType:
        try {
          jsonDecode(value);
        } on FormatException {
          return 'Invalid JSON';
        }
        break;
      case ConfigValueType.stringType:
        break;
    }
    return null;
  }

  EditorDelegate get editorDelegate {
    switch (this) {
      case ConfigValueType.jsonType:
        return JsonEditorDelegate();
      default:
        return StringDelegate();
    }
  }
}

extension ConfigValueExtension on ConfigValue {
  String get displayText {
    switch (type) {
      case ConfigValueType.stringType:
        return asString.isNotEmpty ? asString : '(empty string)';
      default:
        return asString;
    }
  }
}

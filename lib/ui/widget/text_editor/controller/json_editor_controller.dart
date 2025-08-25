import 'dart:convert';

import 'package:local_config/ui/widget/text_editor/controller/text_editor_controller.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/json.dart';
import 'package:re_highlight/styles/atom-one-dark.dart';

class JsonEditorController implements TextEditorController {
  JsonEditorController();

  @override
  CodeEditorStyle? editorStyle = CodeEditorStyle(
    codeTheme: CodeHighlightTheme(
      languages: {'json': CodeHighlightThemeMode(mode: langJson)},
      theme: atomOneDarkTheme,
    ),
  );

  @override
  String minify(String value) {
    try {
      final json = jsonDecode(value);
      var encoder = const JsonEncoder();
      return encoder.convert(json);
    } on FormatException catch (_) {
      return value;
    }
  }

  @override
  String prettify(String value) {
    try {
      final json = jsonDecode(value);
      final spaces = ' ' * 4;
      final encoder = JsonEncoder.withIndent(spaces);
      return encoder.convert(json);
    } on FormatException catch (_) {
      return value;
    }
  }

  @override
  bool? validate(String value) {
    try {
      jsonDecode(value);
      return true;
    } on FormatException catch (_) {
      return false;
    }
  }

  @override
  String title = 'JSON Editor';
}

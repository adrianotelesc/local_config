import 'package:re_editor/re_editor.dart';

abstract class EditorDelegate {
  String get title;

  bool get shouldValidate;

  bool validate(String value);

  String prettify(String value);

  String minify(String value);

  CodeEditorStyle? get editorStyle;
}

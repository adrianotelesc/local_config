import 'package:re_editor/re_editor.dart';

abstract class TextEditorController {
  bool? validate(String value);

  String prettify(String value);

  String minify(String value);

  CodeEditorStyle? get editorStyle;
}

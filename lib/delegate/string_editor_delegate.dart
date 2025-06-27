import 'package:local_config/delegate/editor_delegate.dart';
import 'package:re_editor/re_editor.dart';

class StringDelegate implements EditorDelegate {
  StringDelegate();

  @override
  CodeEditorStyle? editorStyle;

  @override
  String minify(String value) {
    return value;
  }

  @override
  String prettify(String value) {
    return value;
  }

  @override
  bool shouldValidate = false;

  @override
  bool validate(String value) {
    return true;
  }

  @override
  String title = 'String Editor';
}

import 'package:local_config/ui/screen/text_editor/controller/text_editor_controller.dart';
import 'package:re_editor/re_editor.dart';

class StringEditorController implements TextEditorController {
  StringEditorController();

  @override
  CodeEditorStyle? editorStyle;

  @override
  String minify(String value) => value;

  @override
  String prettify(String value) => value;

  @override
  bool? validate(String value) => null;

  @override
  String title = 'String Editor';
}

import 'package:local_config/src/ui/widget/text_editor/controller/text_editor_controller.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/plaintext.dart';
import 'package:re_highlight/styles/atom-one-dark.dart';

class StringEditorController implements TextEditorController {
  StringEditorController();

  @override
  CodeEditorStyle? editorStyle = CodeEditorStyle(
    codeTheme: CodeHighlightTheme(
      languages: {'plaintext': CodeHighlightThemeMode(mode: langPlaintext)},
      theme: atomOneDarkTheme,
    ),
  );

  @override
  String minify(String value) => value;

  @override
  String prettify(String value) => value;

  @override
  bool? validate(String value) => null;
}

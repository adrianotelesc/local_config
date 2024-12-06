import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/json.dart';
import 'package:re_highlight/styles/atom-one-dark.dart';

class TextEditorScreen extends StatefulWidget {
  const TextEditorScreen({
    super.key,
    this.initialValue = '',
  });

  final String initialValue;

  @override
  State<StatefulWidget> createState() => _TextEditorScreenState();
}

class _TextEditorScreenState extends State<TextEditorScreen> {
  final _textController = CodeLineEditingController();

  @override
  void initState() {
    super.initState();
    _textController.text = jsonPrettify(widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(onCloseClick: pop, onSaveClick: popAndResult),
      body: Column(
        children: [
          _FormattingBar(textController: _textController),
          _Editor(textController: _textController),
        ],
      ),
    );
  }

  void pop() {
    Navigator.maybePop(
      context,
      widget.initialValue,
    );
  }

  void popAndResult() {
    Navigator.maybePop(
      context,
      jsonMinify(_textController.text),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({this.onCloseClick, this.onSaveClick});

  final void Function()? onCloseClick;
  final void Function()? onSaveClick;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Editor'),
      leading: IconButton(
        tooltip: 'Close',
        onPressed: onCloseClick,
        icon: const Icon(Icons.close),
      ),
      actions: [
        IconButton(
          tooltip: 'Save',
          onPressed: onSaveClick,
          icon: const Icon(Icons.check),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _FormattingBar extends StatefulWidget {
  const _FormattingBar({required this.textController});

  final CodeLineEditingController textController;

  @override
  State<StatefulWidget> createState() => _FormattingBarState();
}

class _FormattingBarState extends State<_FormattingBar> {
  bool isValid = false;

  Color get primaryColor {
    return isValid ? Colors.greenAccent : Colors.orangeAccent;
  }

  Color get secondaryColor {
    return isValid
        ? const Color.fromARGB(37, 76, 175, 79)
        : const Color.fromARGB(36, 175, 165, 76);
  }

  Color get actionColor {
    return isValid ? Colors.greenAccent : Colors.grey;
  }

  @override
  void initState() {
    super.initState();
    isValid = checkJson(widget.textController.text);
    widget.textController.addListener(_updateValidState);
  }

  void _updateValidState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isValid = checkJson(widget.textController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor),
        color: secondaryColor,
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: primaryColor,
          ),
          const SizedBox.square(
            dimension: 8,
          ),
          Text(
            'Valid JSON',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: primaryColor),
          ),
          const Spacer(),
          TextButton(
            onPressed: isValid
                ? () {
                    widget.textController.text =
                        jsonPrettify(widget.textController.text);
                  }
                : null,
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(
                actionColor,
              ),
            ),
            child: const Text('Format'),
          )
        ],
      ),
    );
  }

  bool checkJson(String jsonString) {
    try {
      jsonDecode(jsonString);
      return true;
    } on FormatException catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    widget.textController.removeListener(_updateValidState);
    super.dispose();
  }
}

class _Editor extends StatelessWidget {
  const _Editor({required this.textController});

  final CodeLineEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CodeEditor(
        shortcutsActivatorsBuilder:
            const DefaultCodeShortcutsActivatorsBuilder(),
        controller: textController,
        indicatorBuilder:
            (context, editingController, chunkController, notifier) {
          return Row(
            children: [
              DefaultCodeLineNumber(
                controller: editingController,
                notifier: notifier,
              ),
              DefaultCodeChunkIndicator(
                  width: 20, controller: chunkController, notifier: notifier)
            ],
          );
        },
        style: CodeEditorStyle(
          fontSize: 16,
          codeTheme: CodeHighlightTheme(
            languages: {'json': CodeHighlightThemeMode(mode: langJson)},
            theme: atomOneDarkTheme,
          ),
        ),
      ),
    );
  }
}

String jsonPrettify(String jsonString) {
  try {
    final json = jsonDecode(jsonString);
    final spaces = ' ' * 4;
    final encoder = JsonEncoder.withIndent(spaces);
    return encoder.convert(json);
  } on FormatException catch (_) {
    return jsonString;
  }
}

String jsonMinify(String jsonString) {
  try {
    final json = jsonDecode(jsonString);
    var encoder = const JsonEncoder();
    return encoder.convert(json);
  } on FormatException catch (_) {
    return jsonString;
  }
}

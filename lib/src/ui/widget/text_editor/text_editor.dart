import 'package:flutter/material.dart';
import 'package:local_config/src/ui/widget/text_editor/controller/text_editor_controller.dart';
import 'package:re_editor/re_editor.dart';

// TODO: Refactor everything about text editor.

class TextEditor extends StatefulWidget {
  const TextEditor({
    super.key,
    this.value = '',
    required this.title,
    required this.controller,
  });

  final String title;
  final String value;
  final TextEditorController controller;

  @override
  State<StatefulWidget> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  final _textController = CodeLineEditingController();

  bool? _isValid;

  @override
  void initState() {
    super.initState();
    _textController.text = widget.controller.prettify(widget.value);
    _textController.addListener(_updateValidState);
    _isValid = widget.controller.validate(_textController.text);
  }

  void _updateValidState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isValid = widget.controller.validate(_textController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      appBar: _AppBar(
        title: widget.title,
        onCloseClick: pop,
        onSaveClick: _isValid ?? true ? popAndResult : null,
      ),
      body: Column(
        children: [
          if (_isValid != null)
            _FormattingBar(
              isValid: _isValid ?? false,
              onFormatClick: () {
                _textController.text = widget.controller.prettify(
                  _textController.text,
                );
              },
            ),
          _Editor(
            textController: _textController,
            textEditorController: widget.controller,
          ),
        ],
      ),
    );
  }

  void pop() {
    Navigator.maybePop(context, widget.value);
  }

  void popAndResult() {
    Navigator.maybePop(context, widget.controller.minify(_textController.text));
  }

  @override
  void dispose() {
    _textController.removeListener(_updateValidState);
    _textController.dispose();
    super.dispose();
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({required this.title, this.onCloseClick, this.onSaveClick});

  final String title;
  final void Function()? onCloseClick;
  final void Function()? onSaveClick;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      title: Text(title),
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
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _FormattingBar extends StatelessWidget {
  const _FormattingBar({required this.isValid, this.onFormatClick});

  final bool isValid;
  final Function()? onFormatClick;

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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor),
        color: secondaryColor,
      ),
      child: Row(
        children: [
          Icon(isValid ? Icons.check_circle : Icons.error, color: primaryColor),
          const SizedBox.square(dimension: 8),
          Text(
            isValid ? 'Valid JSON' : 'Invalid JSON',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: primaryColor),
          ),
          const Spacer(),
          TextButton(
            onPressed: isValid ? onFormatClick : null,
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(actionColor),
            ),
            child: isValid ? const Text('Format') : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _Editor extends StatelessWidget {
  const _Editor({
    required this.textController,
    required this.textEditorController,
  });

  final CodeLineEditingController textController;
  final TextEditorController textEditorController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CodeEditor(
        wordWrap: false,
        autocompleteSymbols: false,
        sperator: Container(
          width: 0.5,
          color: Theme.of(context).colorScheme.surfaceBright,
        ),
        chunkAnalyzer: const DefaultCodeChunkAnalyzer(),
        shortcutsActivatorsBuilder:
            const DefaultCodeShortcutsActivatorsBuilder(),
        controller: textController,
        indicatorBuilder: (_, editingController, chunkController, notifier) {
          return Row(
            children: [
              DefaultCodeLineNumber(
                controller: editingController,
                notifier: notifier,
              ),
              DefaultCodeChunkIndicator(
                width: 20,
                controller: chunkController,
                notifier: notifier,
              ),
            ],
          );
        },
        style: textEditorController.editorStyle,
      ),
    );
  }
}

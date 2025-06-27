import 'package:flutter/material.dart';
import 'package:local_config/delegate/editor_delegate.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/json.dart';
import 'package:re_highlight/styles/atom-one-dark.dart';

class TextEditorScreen extends StatefulWidget {
  const TextEditorScreen({
    super.key,
    this.text = '',
    required this.delegate,
  });

  final String text;
  final EditorDelegate delegate;

  @override
  State<StatefulWidget> createState() => _TextEditorScreenState();
}

class _TextEditorScreenState extends State<TextEditorScreen> {
  final _textController = CodeLineEditingController();

  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _textController.text = widget.delegate.prettify(widget.text);
    _textController.addListener(_updateValidState);
    _isValid = widget.delegate.validate(_textController.text);
  }

  void _updateValidState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isValid = widget.delegate.validate(_textController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(
        title: widget.delegate.title,
        onCloseClick: pop,
        onSaveClick: _isValid ? popAndResult : null,
      ),
      body: Column(
        children: [
          if (widget.delegate.shouldValidate)
            _FormattingBar(
              isValid: _isValid,
              onFormatClick: () {
                _textController.text =
                    widget.delegate.prettify(_textController.text);
              },
            ),
          _Editor(textController: _textController),
        ],
      ),
    );
  }

  void pop() {
    Navigator.maybePop(
      context,
      widget.text,
    );
  }

  void popAndResult() {
    Navigator.maybePop(
      context,
      widget.delegate.minify(_textController.text),
    );
  }

  @override
  void dispose() {
    _textController.removeListener(_updateValidState);
    _textController.dispose();
    super.dispose();
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    required this.title,
    this.onCloseClick,
    this.onSaveClick,
  });

  final String title;
  final void Function()? onCloseClick;
  final void Function()? onSaveClick;

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
        )
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
            onPressed: isValid ? onFormatClick : null,
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
              )
            ],
          );
        },
        style: CodeEditorStyle(
          codeTheme: CodeHighlightTheme(
            languages: {'json': CodeHighlightThemeMode(mode: langJson)},
            theme: atomOneDarkTheme,
          ),
        ),
      ),
    );
  }
}

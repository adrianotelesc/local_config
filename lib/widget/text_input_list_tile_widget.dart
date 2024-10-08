import 'package:flutter/material.dart';

class TextInputListTileWidget extends StatefulWidget {
  const TextInputListTileWidget({
    super.key,
    required this.title,
    required this.value,
    required this.isNumeric,
    this.onChanged,
    this.validator,
  });

  final String title;
  final String value;
  final bool isNumeric;
  final Function(String value)? onChanged;
  final String? Function(String? value)? validator;

  @override
  State<StatefulWidget> createState() => _TextInputListTileWidgetState();
}

class _TextInputListTileWidgetState extends State<TextInputListTileWidget> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  String _value = '';

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _textController.text = _value;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        title: Text(widget.title),
        leading: widget.isNumeric
            ? const Icon(Icons.onetwothree)
            : const Icon(Icons.abc),
        trailing: Text(_value),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(widget.title),
              content: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _textController,
                  autovalidateMode: AutovalidateMode.always,
                  validator: widget.validator,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _textController.text = _value;
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (!(_formKey.currentState?.validate() ?? false)) return;
                    onChanged(_textController.text);
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void onChanged(String value) {
    setState(() => _value = value);
    widget.onChanged?.call(value);
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }
}

import 'package:flutter/material.dart';

class TextInputListTileWidget extends StatefulWidget {
  const TextInputListTileWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    this.textTypeIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.predefinedValues = const [],
  });

  final String title;
  final String subtitle;
  final String value;
  final Widget? textTypeIcon;
  final Widget? suffixIcon;
  final Function(String value)? onChanged;
  final String? Function(String? value)? validator;
  final List<String> predefinedValues;

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
        subtitle: Text(_value.isNotEmpty ? _value : '(empty string)'),
        leading: widget.textTypeIcon,
        contentPadding: const EdgeInsets.only(left: 16, right: 8),
        trailing: IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              useSafeArea: true,
              isScrollControlled: true,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQueryData.fromView(View.of(context))
                              .padding
                              .bottom +
                          MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              widget.textTypeIcon != null
                                  ? widget.textTypeIcon!
                                  : const SizedBox.shrink(),
                              const SizedBox.square(dimension: 4),
                              Text(
                                widget.subtitle,
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Form(
                              key: _formKey,
                              child: widget.predefinedValues.isEmpty
                                  ? TextFormField(
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 16,
                                        ),
                                        border: const OutlineInputBorder(),
                                        suffixIcon: widget.suffixIcon,
                                      ),
                                      controller: _textController,
                                      autovalidateMode: AutovalidateMode.always,
                                      validator: widget.validator,
                                    )
                                  : DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButtonFormField<String>(
                                            isDense: false,
                                            itemHeight: 48,
                                            decoration: InputDecoration(
                                              border:
                                                  const OutlineInputBorder(),
                                              suffixIcon: widget.suffixIcon,
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      right: 4),
                                            ),
                                            items: widget.predefinedValues
                                                .map((value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            value: _value,
                                            onChanged: (value) {
                                              _textController.text =
                                                  value ?? _value;
                                            }),
                                      ),
                                    ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  _textController.text = _value;
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              const SizedBox.square(dimension: 8),
                              FilledButton(
                                onPressed: () {
                                  if (!(_formKey.currentState?.validate() ??
                                      false)) {
                                    return;
                                  }
                                  onChanged(_textController.text);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Save'),
                              ),
                            ],
                          )
                        ],
                      )),
                );
              },
            ).whenComplete(() {
              _textController.text = _value;
            });
          },
          icon: const Icon(Icons.edit),
        ),
      ),
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

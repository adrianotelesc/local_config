import 'package:flutter/material.dart';

class InputFormField extends StatelessWidget {
  final TextStyle? textStyle;
  final MenuStyle? menuStyle;
  final Widget label;
  final TextEditingController controller;
  final List<DropdownMenuEntry<String>> entries;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String? value)? validator;
  final Widget? suffixIcon;
  final bool enabled;

  InputFormField({
    super.key,
    TextEditingController? controller,
    this.textStyle,
    this.menuStyle,
    this.entries = const [],
    this.autofocus = false,
    this.onFieldSubmitted,
    this.validator,
    this.textInputAction,
    this.suffixIcon,
    this.enabled = true,
    this.label = const SizedBox.shrink(),
  }) : controller = controller ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        label,
        entries.isNotEmpty
            ? _DropdownMenu(
              textStyle: textStyle,
              enabled: enabled,
              controller: controller,
              entries: entries,
            )
            : _TextFormField(
              style: textStyle,
              controller: controller,
              suffixIcon: suffixIcon,
              textInputAction: textInputAction,
              autofocus: autofocus,
              onFieldSubmitted: onFieldSubmitted,
              validator: validator,
              enabled: enabled,
            ),
      ],
    );
  }
}

class _TextFormField extends StatelessWidget {
  final TextStyle? style;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String? value)? validator;
  final bool enabled;

  const _TextFormField({
    required this.controller,
    this.style,
    this.suffixIcon,
    this.textInputAction,
    this.autofocus = false,
    this.onFieldSubmitted,
    required this.validator,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: style,
      ignorePointers: false,
      scrollPhysics: AlwaysScrollableScrollPhysics(),
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        suffixIcon: suffixIcon,
      ),
      textInputAction: textInputAction,
      autofocus: autofocus,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      enabled: enabled,
      autovalidateMode: AutovalidateMode.always,
    );
  }
}

class _DropdownMenu extends StatelessWidget {
  final TextStyle? textStyle;
  final bool enabled;
  final TextEditingController controller;
  final List<DropdownMenuEntry<String>> entries;

  const _DropdownMenu({
    this.enabled = true,
    this.textStyle,
    required this.controller,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      enabled: enabled,
      textStyle: textStyle?.copyWith(
        color: enabled ? null : textStyle?.color?.withAlpha(87),
      ),
      leadingIcon:
          entries
              .where((item) => item.value == controller.text)
              .firstOrNull
              ?.leadingIcon,
      controller: controller,
      expandedInsets: EdgeInsets.zero,
      dropdownMenuEntries: entries,
    );
  }
}

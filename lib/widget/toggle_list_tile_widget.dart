import 'package:flutter/material.dart';

class ToggleListTileWidget extends StatefulWidget {
  const ToggleListTileWidget({
    super.key,
    required this.title,
    required this.value,
    this.onChanged,
  });

  final String title;
  final bool value;
  final Function(bool)? onChanged;

  @override
  State<StatefulWidget> createState() => _ToggleListTileWidgetState();
}

class _ToggleListTileWidgetState extends State<ToggleListTileWidget> {
  var _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        title: Text(widget.title),
        leading: const Icon(Icons.toggle_on),
        trailing: Switch(
          value: _value,
          onChanged: onChanged,
        ),
      ),
      onTap: () => onChanged(!_value),
    );
  }

  void onChanged(final bool value) async {
    setState(() => _value = value);
    widget.onChanged?.call(value);
  }
}

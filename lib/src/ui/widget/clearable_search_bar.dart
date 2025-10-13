import 'package:flutter/material.dart';

class ClearableSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;

  const ClearableSearchBar({
    super.key,
    this.controller,
    this.hintText,
  });

  @override
  State<StatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<ClearableSearchBar> {
  late final TextEditingController _controller;

  var _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    final text = widget.controller?.text ?? '';
    setState(() => _showClearButton = text.isNotEmpty);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _controller.removeListener(_handleTextChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: _controller,
      hintText: widget.hintText,
      trailing: [
        if (_showClearButton)
          Tooltip(
            message: 'Clear',
            child: IconButton(
              onPressed: _controller.clear,
              icon: const Icon(Icons.close),
            ),
          ),
      ],
      leading: const Icon(Icons.search),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.only(
          left: 16,
          right: 4,
        ),
      ),
    );
  }
}

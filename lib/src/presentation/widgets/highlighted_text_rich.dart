import 'package:flutter/material.dart';

class HighlightText extends StatelessWidget {
  final String text;
  final Set<String> terms;
  final TextStyle? style;
  final Color? highlightColor;
  final int? maxLines;
  final TextOverflow? overflow;

  const HighlightText({
    super.key,
    this.style,
    this.highlightColor,
    this.maxLines,
    this.overflow,
    required this.text,
    required this.terms,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      _buildSpans(
        text: text,
        terms: terms,
        style: style,
        highlightStyle: style?.copyWith(
          backgroundColor:
              highlightColor ?? ColorScheme.of(context).primary.withAlpha(102),
        ),
      ),
      maxLines: maxLines,
      overflow: overflow,
      style: style,
    );
  }

  static TextSpan _buildSpans({
    required String text,
    required Set<String> terms,
    TextStyle? style,
    TextStyle? highlightStyle,
  }) {
    if (terms.isEmpty) {
      return TextSpan(text: text, style: style);
    }

    final escaped = terms.map(RegExp.escape);
    final pattern = RegExp('(${escaped.join('|')})', caseSensitive: false);
    final matches = pattern.allMatches(text);

    if (matches.isEmpty) {
      return TextSpan(text: text, style: style);
    }

    final spans = <TextSpan>[];
    int start = 0;

    for (final match in matches) {
      if (match.start > start) {
        spans.add(
          TextSpan(text: text.substring(start, match.start), style: style),
        );
      }

      spans.add(TextSpan(text: match.group(0), style: highlightStyle));

      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: style));
    }

    return TextSpan(children: spans);
  }
}

import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedFloatingText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final double amplitude;
  final Duration period;
  final TextAlign textAlign;

  const AnimatedFloatingText(
    this.text, {
    super.key,
    this.style,
    this.amplitude = 1,
    this.period = const Duration(seconds: 2),
    this.textAlign = TextAlign.start,
  });

  @override
  State<AnimatedFloatingText> createState() => _AnimatedFloatingTextState();
}

class _AnimatedFloatingTextState extends State<AnimatedFloatingText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<double> _phaseX;
  late final List<double> _phaseY;
  late final List<String> _wordsWithSpaces;
  final _random = Random();

  @override
  void initState() {
    super.initState();

    _wordsWithSpaces = RegExp(r'(\S+\s*)')
        .allMatches(widget.text)
        .map((m) => m.group(0)!)
        .toList();

    int totalLetters = widget.text.length;
    _phaseX = List.generate(
      totalLetters,
      (_) => _random.nextDouble() * 2 * pi,
    );
    _phaseY = List.generate(
      totalLetters,
      (_) => _random.nextDouble() * 2 * pi,
    );

    _controller = AnimationController(vsync: this, duration: widget.period)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? DefaultTextStyle.of(context).style;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        int globalIndex = 0;

        return RichText(
          textAlign: widget.textAlign,
          text: TextSpan(
            style: style,
            children: _wordsWithSpaces.map((wordWithSpace) {
              final startIndex = globalIndex;
              globalIndex += wordWithSpace.length;

              return WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(wordWithSpace.length, (i) {
                    final letterIndex = startIndex + i;
                    final offsetX =
                        sin(_controller.value * 2 * pi + _phaseX[letterIndex]) *
                            widget.amplitude;
                    final offsetY =
                        cos(_controller.value * 2 * pi + _phaseY[letterIndex]) *
                            widget.amplitude;

                    return Transform.translate(
                      offset: Offset(offsetX, offsetY),
                      child: Text(wordWithSpace[i], style: style),
                    );
                  }),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

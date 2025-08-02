import 'package:flutter/material.dart';
import 'package:local_config/ui/theming/extended_color_scheme.dart';

class Callout extends StatelessWidget {
  static const double defaultHeight = 58;

  final _CalloutVariant _variant;
  final CalloutStyle? style;
  final IconData? icon;
  final String text;
  final Widget? trailing;
  final double height;

  const Callout.warning({
    super.key,
    this.style,
    this.icon,
    required this.text,
    this.trailing,
    this.height = defaultHeight,
  }) : _variant = _CalloutVariant.warning;

  const Callout.success({
    super.key,
    this.style,
    this.icon,
    required this.text,
    this.trailing,
    this.height = defaultHeight,
  }) : _variant = _CalloutVariant.success;

  @override
  Widget build(BuildContext context) {
    final extendedColors = context.extendedColorScheme;

    final foregroundColor =
        style?.foregroundColor ?? _variant.foregroundColor(extendedColors);
    final borderColor =
        style?.borderColor ?? _variant.borderColor(extendedColors);
    final backgroundColor =
        style?.backgroundColor ?? _variant.backgroundColor(extendedColors);

    return Container(
      height: height,
      padding: const EdgeInsets.only(
        left: 16,
        top: 4,
        right: 8,
        bottom: 4,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        color: backgroundColor,
        borderRadius: style?.borderRadius,
      ),
      child: Row(
        children: [
          if (icon != null)
            Icon(
              icon,
              color: foregroundColor,
            ),
          const SizedBox.square(dimension: 8),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: foregroundColor),
          ),
          const Spacer(),
          trailing ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}

enum _CalloutVariant {
  success,
  warning;

  Color foregroundColor(ExtendedColorScheme extendedColors) {
    return switch (this) {
      success => extendedColors.success,
      warning => extendedColors.warning,
    };
  }

  Color backgroundColor(ExtendedColorScheme extendedColors) {
    return switch (this) {
      success => extendedColors.successContainer,
      warning => extendedColors.warningContainer,
    };
  }

  Color borderColor(ExtendedColorScheme extendedColors) {
    return switch (this) {
      success => extendedColors.onSuccessContainer,
      warning => extendedColors.onWarningContainer,
    };
  }
}

class CalloutStyle {
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  CalloutStyle({
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });
}

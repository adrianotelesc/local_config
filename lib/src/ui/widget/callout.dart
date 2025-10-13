import 'package:flutter/material.dart';
import 'package:local_config/src/ui/theming/extended_color_scheme.dart';

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
    final extendedColorScheme = context.extendedColorScheme;

    final foregroundColor =
        style?.foregroundColor ?? _variant.foregroundColor(extendedColorScheme);
    final borderColor =
        style?.borderColor ?? _variant.borderColor(extendedColorScheme);
    final backgroundColor =
        style?.backgroundColor ?? _variant.backgroundColor(extendedColorScheme);

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
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: foregroundColor),
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

  Color foregroundColor(ExtendedColorScheme extendedColorScheme) {
    return switch (this) {
      success => extendedColorScheme.success,
      warning => extendedColorScheme.warning,
    };
  }

  Color backgroundColor(ExtendedColorScheme extendedColorScheme) {
    return switch (this) {
      success => extendedColorScheme.successContainer,
      warning => extendedColorScheme.warningContainer,
    };
  }

  Color borderColor(ExtendedColorScheme extendedColorScheme) {
    return switch (this) {
      success => extendedColorScheme.onSuccessContainer,
      warning => extendedColorScheme.onWarningContainer,
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

import 'package:flutter/material.dart';

class ExtendedColorScheme extends ThemeExtension<ExtendedColorScheme> {
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;

  ExtendedColorScheme({
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
  });

  @override
  ThemeExtension<ExtendedColorScheme> copyWith({
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
  }) {
    return ExtendedColorScheme(
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
    );
  }

  @override
  ThemeExtension<ExtendedColorScheme> lerp(
    covariant ThemeExtension<ExtendedColorScheme>? other,
    double t,
  ) {
    if (other is! ExtendedColorScheme) {
      return this;
    }

    return ExtendedColorScheme(
      warning: Color.lerp(
        warning,
        other.warning,
        t,
      )!,
      onWarning: Color.lerp(
        onWarning,
        other.onWarning,
        t,
      )!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      )!,
      success: Color.lerp(
        success,
        other.success,
        t,
      )!,
      onSuccess: Color.lerp(
        onSuccess,
        other.onSuccess,
        t,
      )!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      )!,
    );
  }
}

extension BuildContextThemeExtension on BuildContext {
  ExtendedColorScheme get extendedColorScheme {
    final extendedColors = Theme.of(this).extension<ExtendedColorScheme>();
    if (extendedColors == null) {
      throw StateError('ExtendedColorScheme not found in the theme context.');
    }
    return extendedColors;
  }
}

import 'package:flutter/material.dart';
import 'package:local_config/src/ui/widget/extended_list_tile.dart';

abstract final class LocalConfigTheme {
  static ColorScheme get _colorScheme => ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: Color(0xFF1A73E8),
  );

  static ThemeData get _base => ThemeData(
    useMaterial3: true,
    colorScheme: _colorScheme,
    fontFamily: 'GoogleSans',
    package: 'local_config',
    inputDecorationTheme: _inputDecorationTheme,
  );

  static InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: _colorScheme.outline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: _colorScheme.outline),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: _colorScheme.onSurface.withAlpha(23)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: _colorScheme.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: _colorScheme.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: _colorScheme.error, width: 2),
    ),
  );

  static ThemeData get data => _base.copyWith(
    appBarTheme: _base.appBarTheme.copyWith(
      backgroundColor: _colorScheme.surface,
      surfaceTintColor: _colorScheme.surface,
    ),
    dropdownMenuTheme: _base.dropdownMenuTheme.copyWith(
      textStyle: _base.dropdownMenuTheme.textStyle?.copyWith(
        color: _colorScheme.onSurface,
      ),
      menuStyle: MenuStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    ),
    bottomSheetTheme: _base.bottomSheetTheme.copyWith(
      shape: RoundedRectangleBorder(),
    ),
    searchBarTheme: _base.searchBarTheme.copyWith(
      shadowColor: const WidgetStatePropertyAll(Colors.transparent),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: _base.filledButtonTheme.style?.copyWith(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: _base.filledButtonTheme.style?.copyWith(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    ),
    textSelectionTheme: _base.textSelectionTheme.copyWith(
      cursorColor: _colorScheme.primary,
      selectionColor: _colorScheme.primary.withAlpha(102),
      selectionHandleColor: _colorScheme.primary,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: _colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    extensions: [
      ExtendedColorScheme(
        warning: Color(0XFFFFB300),
        warningContainer: Color(0X14FFB300),
        onWarning: Color(0XFF000000),
        onWarningContainer: Color(0X4DFFB300),
        success: Color(0XFF6DD58C),
        onSuccess: Color(0XFF000000),
        successContainer: Color(0X146DD58C),
        onSuccessContainer: Color(0X4D6DD58C),
      ),
    ],
  );
}

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
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer:
          Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer:
          Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer:
          Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer:
          Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
    );
  }
}

ButtonStyle warningButtonStyle(BuildContext context) {
  final colorScheme = Theme.of(context).extension<ExtendedColorScheme>();
  assert(colorScheme != null, 'ExtendedColorScheme must be available in theme');
  return ButtonStyle(
    overlayColor: WidgetStatePropertyAll(colorScheme?.warningContainer),
    foregroundColor: WidgetStatePropertyAll(colorScheme?.warning),
  );
}

ExtendedListTileStyle warningExtendedListTileStyle(BuildContext context) {
  final colorScheme = Theme.of(context).extension<ExtendedColorScheme>();
  assert(colorScheme != null, 'ExtendedColorScheme must be available in theme');
  return ExtendedListTileStyle(
    tileColor: colorScheme?.warningContainer,
    titleTextStyle: TextTheme.of(context) //
    .bodyLarge?.copyWith(fontWeight: FontWeight.bold),
    subtitleTextStyle: TextTheme.of(context) //
    .bodyMedium?.copyWith(fontWeight: FontWeight.bold),
  );
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

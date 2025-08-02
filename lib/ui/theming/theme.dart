import 'package:flutter/material.dart';
import 'package:local_config/ui/theming/colors.dart';
import 'package:local_config/ui/theming/extended_color_scheme.dart';

final defaultTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: seedColor,
    primary: primary,
    onPrimary: onPrimary,
    surface: surface,
  ),
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: surface,
    surfaceTintColor: surface,
  ),
  searchBarTheme: SearchBarThemeData(
    shadowColor: const WidgetStatePropertyAll(
      Colors.transparent,
    ),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  ),
  extensions: [
    ExtendedColorScheme(
      warning: warning,
      warningContainer: warningContainer,
      onWarning: onWarning,
      onWarningContainer: onWarningContainer,
      success: success,
      onSuccess: onSuccess,
      successContainer: successContainer,
      onSuccessContainer: onSuccessContainer,
    ),
  ],
);

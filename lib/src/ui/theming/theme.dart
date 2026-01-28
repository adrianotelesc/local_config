import 'package:flutter/material.dart';
import 'package:local_config/src/ui/theming/colors.dart';
import 'package:local_config/src/ui/theming/extended_color_scheme.dart';

// TODO: Refactor all about theme.

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
  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    ),
    menuStyle: MenuStyle(
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 0)),
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(shape: RoundedRectangleBorder()),
  searchBarTheme: SearchBarThemeData(
    shadowColor: const WidgetStatePropertyAll(Colors.transparent),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

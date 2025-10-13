import 'package:flutter/material.dart';
import 'package:local_config/src/ui/theming/extended_color_scheme.dart';
import 'package:local_config/src/ui/widget/extended_list_tile.dart';

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

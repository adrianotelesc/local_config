import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:local_config/src/presentation/l10n/generated/local_config_localizations.dart';
import 'package:local_config/src/presentation/local_config_routes.dart';
import 'package:local_config/src/presentation/local_config_theme.dart';
import 'package:local_config/src/presentation/screens/config_edit_screen.dart';
import 'package:local_config/src/presentation/screens/config_list_screen.dart';

/// The entry point widget for Local Config UI.
class LocalConfigEntrypoint extends StatelessWidget {
  /// Creates a entry point for Local Config UI.
  const LocalConfigEntrypoint({super.key});

  @override
  Widget build(BuildContext context) {
    return Localizations(
      locale: Localizations.maybeLocaleOf(context) ?? const Locale('en'),
      delegates: const [
        LocalConfigLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      child: Theme(
        data: LocalConfigTheme.data,
        child: Navigator(
          initialRoute: LocalConfigRoutes.configList,
          onGenerateRoute: (settings) {
            return switch (settings.name) {
              LocalConfigRoutes.configList => MaterialPageRoute(
                builder: (_) => const ConfigListScreen(),
              ),
              LocalConfigRoutes.configEdit => MaterialPageRoute(
                fullscreenDialog: true,
                builder:
                    (_) =>
                        ConfigEditScreen(name: settings.arguments.toString()),
              ),
              _ => null,
            };
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:local_config/ui/l10n/local_config_localizations.dart';
import 'package:local_config/ui/local_config_routes.dart';
import 'package:local_config/ui/page/config_edit_page.dart';
import 'package:local_config/ui/page/config_list_page.dart';

class LocalConfigEntrypoint extends StatelessWidget {
  const LocalConfigEntrypoint({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Localizations(
      locale: Localizations.localeOf(context),
      delegates: const [
        LocalConfigLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      child: Navigator(
        initialRoute: LocalConfigRoutes.configList,
        onGenerateRoute: (settings) {
          return switch (settings.name) {
            LocalConfigRoutes.configList => MaterialPageRoute(
              builder: (_) => const ConfigListScreen(),
            ),
            LocalConfigRoutes.configEdit => MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) {
                return ConfigEditScreen(
                  name: settings.arguments.toString(),
                );
              },
            ),
            _ => null,
          };
        },
      ),
    );
  }
}

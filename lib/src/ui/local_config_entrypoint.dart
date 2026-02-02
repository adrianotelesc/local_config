import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:local_config/src/core/di/service_locator.dart';
import 'package:local_config/src/infra/di/internal_service_locator.dart';
import 'package:local_config/src/ui/l10n/local_config_localizations.dart';
import 'package:local_config/src/ui/local_config_routes.dart';
import 'package:local_config/src/ui/page/config_edit_page.dart';
import 'package:local_config/src/ui/page/config_list_page.dart';
import 'package:local_config/src/ui/local_config_theme.dart';
import 'package:provider/provider.dart';

class LocalConfigEntrypoint extends StatelessWidget {
  const LocalConfigEntrypoint({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [Provider<ServiceLocator>.value(value: serviceLocator)],
      child: Localizations(
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
                  builder: (_) => const ConfigListPage(),
                ),
                LocalConfigRoutes.configEdit => MaterialPageRoute(
                  fullscreenDialog: true,
                  builder:
                      (_) =>
                          ConfigEditPage(name: settings.arguments.toString()),
                ),
                _ => null,
              };
            },
          ),
        ),
      ),
    );
  }
}

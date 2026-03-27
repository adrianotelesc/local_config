import 'dart:async';

import 'package:flutter/material.dart';
import 'package:local_config/local_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalConfig.instance.initialize(
    configSettings: LocalConfigSettings(
      keyValueStorage: SharedPreferencesKeyValueStorage(
        sharedPreferences: SharedPreferencesAsync(),
      ),
    ),
  );
  await LocalConfig.instance.setDefaults({
    'social_login_enabled': false,
    'timeout_ms': 8000,
    'animation_speed': 1.25,
    'api_base_url': 'https://api.myapp.com/v1',
    "checkout": {
      "payment_methods": {
        "allowed": ["credit_card", "pix", "boleto"],
        "default": "credit_card",
      },
      "installments": {
        "enabled": false,
        "rules": [
          {"max_installments": 3, "min_order_value": 0},
          {"max_installments": 6, "min_order_value": 100},
          {"max_installments": 10, "min_order_value": 300},
        ],
      },
    },
  });

  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) =>
      MaterialApp(debugShowCheckedModeBanner: false, home: const ExamplePage());
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Local Config Example')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => LocalConfigEntrypoint()));
        },
        child: const Icon(Icons.edit),
      ),
      body: _ConfigListView(),
    );
  }
}

class _ConfigListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ConfigListViewState();
}

class _ConfigListViewState extends State<_ConfigListView> {
  List<MapEntry<String, LocalConfigValue>> _configEntries = [];

  StreamSubscription? _configUpdateSub;

  @override
  void initState() {
    super.initState();
    _configEntries = LocalConfig.instance.all.entries.toList();

    _configUpdateSub = LocalConfig.instance.onConfigUpdated.listen((configs) {
      setState(
        () => _configEntries = LocalConfig.instance.all.entries.toList(),
      );
    });
  }

  @override
  void dispose() {
    _configUpdateSub?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _configEntries.length,
      itemBuilder: (_, index) {
        final configEntry = _configEntries[index];

        final key = configEntry.key;
        final value = configEntry.value;

        return ListTile(title: Text(key), subtitle: Text(value.asString));
      },
    );
  }
}

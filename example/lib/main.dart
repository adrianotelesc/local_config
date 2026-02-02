import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_config/local_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LocalConfig.instance.initialize(
    params: {
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
    },
    store: SecureStorageKeyValueStore(
      secureStorage: const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      ),
    ),
  );

  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(home: const ExamplePage());
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
  List<MapEntry<String, Object>> _configEntries = [];

  StreamSubscription? _configUpdateSub;

  @override
  void initState() {
    super.initState();

    _configUpdateSub = LocalConfig.instance.onConfigUpdated.listen((configs) {
      setState(() => _configEntries = configs.entries.toList());
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

        return ListTile(title: Text(key), subtitle: Text(value.toString()));
      },
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:local_config/local_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final configs = <String, String>{
    'app_name': 'Local Config Example',
    'app_version': '1.0.0',
    'api_base_url': 'https://api.example.com',
    'feature_x_enabled': 'true',
    'max_items': '100',
  };
  await LocalConfig.instance.initialize(configs: configs);
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  static const title = 'Local Config Example';

  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      home: const ExamplePage(title: title),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key, required this.title});

  final String title;

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  Map<String, String> _configs = {};
  StreamSubscription? _configSub;

  @override
  void initState() {
    super.initState();
    _configSub = LocalConfig.instance.onConfigUpdated.listen((configs) {
      setState(() => _configs = configs);
    });
  }

  @override
  void dispose() {
    _configSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _configs.length,
        itemBuilder: (context, index) {
          final key = _configs.keys.elementAt(index);
          final value = _configs[key];

          return ListTile(
            title: Text(key),
            subtitle: Text(value?.toString() ?? 'null'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LocalConfigScreen()),
          );
        },
        tooltip: 'Local Config',
        child: const Icon(Icons.settings),
      ),
    );
  }
}

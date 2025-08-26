import 'dart:async';

import 'package:flutter/material.dart';
import 'package:local_config/local_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final configs = <String, String>{
    'config_string': 'Local Config Example',
    'config_number': '1',
    'config_boolean': 'false',
    'config_json': '{}',
  };
  LocalConfig.instance.initialize(configs: configs);
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
      debugShowCheckedModeBanner: false,
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
        actionsPadding: EdgeInsets.all(8),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocalConfig.instance.screen,
                ),
              );
            },
            tooltip: 'Local Config',
            icon: const Icon(Icons.settings),
          ),
        ],
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
    );
  }
}

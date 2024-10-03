import 'dart:convert';

import 'package:firebase_local_config/widget/toggle_config_widget.dart';
import 'package:firebase_local_config/widget/data_object_config_widget.dart';
import 'package:firebase_local_config/widget/text_config_widget.dart';
import 'package:flutter/material.dart';

class LocalConfigScreen extends StatelessWidget {
  final List<MapEntry<String, String>> configs;

  const LocalConfigScreen({super.key, required this.configs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Config')),
      body: ListView.builder(
        itemCount: configs.length,
        itemBuilder: (context, index) {
          final configEntry = configs[index];

          final boolValue = bool.tryParse(configEntry.value);
          if (boolValue != null) {
            return ToggleConfigWidget(
              configKey: configEntry.key,
              configValue: boolValue,
            );
          }

          try {
            final jsonValue = jsonDecode(configEntry.value);
            if (jsonValue is Map<String, dynamic>) {
              return DataObjectConfigWidget(
                configKey: configEntry.key,
                configValue: configEntry.value,
              );
            }
          } on FormatException catch (_) {}

          return TextConfigWidget(
            configKey: configEntry.key,
            configValue: configEntry.value,
          );
        },
      ),
    );
  }
}

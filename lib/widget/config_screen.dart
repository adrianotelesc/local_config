import 'package:flutter/material.dart';
import 'package:firebase_local_config/local_config.dart';
import 'package:firebase_local_config/model/config_value.dart';
import 'package:firebase_local_config/widget/toggle_list_tile_widget.dart';
import 'package:firebase_local_config/widget/data_object_config_widget.dart';
import 'package:firebase_local_config/widget/text_input_list_tile_widget.dart';

class LocalConfigScreen extends StatelessWidget {
  final List<MapEntry<String, ConfigValue>> configs;

  const LocalConfigScreen({
    super.key,
    required this.configs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Config')),
      body: ListView.builder(
        itemCount: configs.length,
        itemBuilder: (context, index) {
          final configEntry = configs[index];

          switch (configEntry.value.valueType) {
            case ConfigValueType.bool:
              return ToggleListTileWidget(
                title: configEntry.key,
                value: configEntry.value.asBool() ?? false,
                onChanged: (value) =>
                    LocalConfig.instance.setBool(configEntry.key, value),
              );

            case ConfigValueType.int:
            case ConfigValueType.double:
            case ConfigValueType.string:
              return TextInputListTileWidget(
                title: configEntry.key,
                value: configEntry.value.asString() ?? '',
                isNumeric: configEntry.value.isNumeric,
                onChanged: (value) {
                  if (configEntry.value.valueType == ConfigValueType.int) {
                    LocalConfig.instance.setInt(
                      configEntry.key,
                      int.tryParse(value) ?? 0,
                    );
                  }

                  if (configEntry.value.valueType == ConfigValueType.double) {
                    LocalConfig.instance.setDouble(
                      configEntry.key,
                      double.tryParse(value) ?? 0,
                    );
                  }

                  if (configEntry.value.valueType == ConfigValueType.string) {
                    LocalConfig.instance.setString(
                      configEntry.key,
                      value,
                    );
                  }
                },
                validator: (value) {
                  if (configEntry.value.valueType == ConfigValueType.int &&
                      value != null &&
                      int.tryParse(value) == null) {
                    return 'Invalid integer.';
                  }

                  if (configEntry.value.valueType == ConfigValueType.double &&
                      value != null &&
                      double.tryParse(value) == null) {
                    return 'Invalid double.';
                  }

                  return null;
                },
              );

            case ConfigValueType.json:
              return DataObjectConfigWidget(
                configKey: configEntry.key,
                configValue: configEntry.value,
              );
          }
        },
      ),
    );
  }
}

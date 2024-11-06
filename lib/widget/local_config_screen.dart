import 'package:firebase_local_config/widget/text_editor_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_local_config/local_config.dart';
import 'package:firebase_local_config/model/config_value.dart';
import 'package:firebase_local_config/widget/text_input_list_tile_widget.dart';

class LocalConfigScreen extends StatelessWidget {
  final List<MapEntry<String, ConfigValue>> configs;

  final _searchTextController = TextEditingController();

  LocalConfigScreen({
    super.key,
    required this.configs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Config'),
        centerTitle: false,
      ),
      body: ListView.separated(
        itemCount: configs.length + 1,
        separatorBuilder: (context, index) {
          return const Divider(height: 1);
        },
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: TextField(
                controller: _searchTextController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                ),
              ),
            );
          }
          index = index -= 1;
          final configEntry = configs[index];

          switch (configEntry.value.valueType) {
            case ConfigValueType.bool:
              return TextInputListTileWidget(
                title: configEntry.key,
                subtitle: _getType(configEntry.value.valueType),
                value: configEntry.value.value,
                predefinedValues: const ['false', 'true'],
                textTypeIcon: const Icon(Icons.toggle_on),
                validator: (value) {
                  if (configEntry.value.valueType == ConfigValueType.bool &&
                      value != null &&
                      bool.tryParse(value) == null) {
                    return 'Invalid boolean.';
                  }

                  return null;
                },
                onChanged: (value) =>
                    LocalConfig.instance.setString(configEntry.key, value),
              );

            case ConfigValueType.int:
            case ConfigValueType.double:
            case ConfigValueType.string:
            case ConfigValueType.json:
              final isNumeric =
                  configEntry.value.valueType == ConfigValueType.int ||
                      configEntry.value.valueType == ConfigValueType.double;
              final isJson =
                  configEntry.value.valueType == ConfigValueType.json;
              return TextInputListTileWidget(
                title: configEntry.key,
                subtitle: _getType(configEntry.value.valueType),
                value: configEntry.value.asString() ?? '',
                textTypeIcon: isNumeric
                    ? const Icon(Icons.onetwothree)
                    : isJson
                        ? const Icon(Icons.data_object)
                        : const Icon(Icons.abc),
                suffixIcon: configEntry.value.valueType ==
                            ConfigValueType.json ||
                        configEntry.value.valueType == ConfigValueType.string
                    ? IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<Null>(
                                builder: (BuildContext context) {
                                  return TextEditorScreen(
                                    value: configEntry.value.value,
                                  );
                                },
                                fullscreenDialog: true),
                          );
                        },
                        icon: const Icon(Icons.open_in_full),
                      )
                    : null,
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
          }
        },
      ),
    );
  }

  String _getType(ConfigValueType type) {
    switch (type) {
      case ConfigValueType.bool:
        return 'bool';
      case ConfigValueType.int:
        return 'int';
      case ConfigValueType.double:
        return 'double';
      case ConfigValueType.string:
        return 'String';
      case ConfigValueType.json:
        return 'JSON';
    }
  }
}

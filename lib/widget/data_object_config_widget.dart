import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class DataObjectConfigWidget extends StatefulWidget {
  const DataObjectConfigWidget({
    super.key,
    required this.configKey,
    required this.configValue,
  });

  final String configKey;
  final String configValue;

  @override
  State<StatefulWidget> createState() => _DataObjectConfigWidgetState();
}

class _DataObjectConfigWidgetState extends State<DataObjectConfigWidget> {
  String value = RemoteConfigValue.defaultValueForString;

  @override
  void initState() {
    super.initState();
    value = widget.configValue;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        title: Text(widget.configKey),
        leading: const Icon(Icons.data_object),
        trailing: Text(widget.configValue),
      ),
      onTap: () {
        showAdaptiveDialog(
          context: context,
          builder: (context) {
            return const Column(
              children: [
                TextField(),
              ],
            );
          },
        );
      },
    );
  }

  void onChanged(String value) {
    setState(() {
      this.value = value;
    });
  }
}

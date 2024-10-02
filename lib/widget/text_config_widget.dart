import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class TextConfigWidget extends StatefulWidget {
  const TextConfigWidget({
    super.key,
    required this.configKey,
    required this.configValue,
  });

  final String configKey;
  final String configValue;

  @override
  State<StatefulWidget> createState() => _TextConfigWidgetState();
}

class _TextConfigWidgetState extends State<TextConfigWidget> {
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
        subtitle: const Text('String'),
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

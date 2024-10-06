import 'package:firebase_local_config/local_config.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class ToggleConfigWidget extends StatefulWidget {
  const ToggleConfigWidget({
    super.key,
    required this.configKey,
    required this.configValue,
  });

  final String configKey;
  final bool configValue;

  @override
  State<StatefulWidget> createState() => _ToggleConfigWidgetState();
}

class _ToggleConfigWidgetState extends State<ToggleConfigWidget> {
  bool value = RemoteConfigValue.defaultValueForBool;

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
        leading: const Icon(Icons.toggle_on),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
        ),
      ),
      onTap: () {
        onChanged(!value);
      },
    );
  }

  void onChanged(bool value) async {
    setState(() {
      this.value = value;
    });
    await LocalConfig.instance.setBool(widget.configKey, value);
  }
}

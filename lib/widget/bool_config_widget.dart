import 'package:firebase_local_config/local_config.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class BoolConfigWidget extends StatefulWidget {
  const BoolConfigWidget({
    super.key,
    required this.configKey,
    required this.configValue,
  });

  final String configKey;
  final bool configValue;

  @override
  State<StatefulWidget> createState() => _BoolConfigWidgetState();
}

class _BoolConfigWidgetState extends State<BoolConfigWidget> {
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
        subtitle: const Text('bool'),
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
        ),
      ),
      onTap: () {
        onChanged(!value);
      },
    );
  }

  void onChanged(bool value) {
    setState(() {
      this.value = value;
    });
    LocalConfig.instance.setBool(widget.configKey, value);
  }
}

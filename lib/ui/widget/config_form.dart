import 'package:flutter/material.dart';
import 'package:local_config/di/service_locator.dart';
import 'package:local_config/repository/config_repository.dart';
import 'package:local_config/ui/screen/text_editor/text_editor_screen.dart';
import 'package:local_config/extension/config_extension.dart';
import 'package:local_config/model/config.dart';

class ConfigForm extends StatefulWidget {
  const ConfigForm({
    super.key,
    required this.configName,
    required this.configValue,
  });

  final String configName;
  final Config configValue;

  @override
  State<StatefulWidget> createState() => _ConfigFormState();

  static void showAsBottomSheet({
    required BuildContext context,
    required String name,
    required Config value,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return ConfigForm(configName: name, configValue: value);
      },
    );
  }
}

class _ConfigFormState extends State<ConfigForm> {
  final _configFormKey = GlobalKey<FormState>();
  final _configValueController = TextEditingController();

  String _value = '';

  @override
  void initState() {
    super.initState();
    _value = widget.configValue.value;
    _configValueController.text = _value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      child: Form(
        key: _configFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit parameter',
                    style: TextTheme.of(context).titleLarge,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),
            const SizedBox.square(dimension: 8),
            const Divider(),
            const SizedBox.square(dimension: 8),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Column(
                    spacing: 8,
                    children: [
                      Tooltip(
                        preferBelow: false,
                        showDuration: const Duration(seconds: 3),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.inverseSurface,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                        triggerMode: TooltipTriggerMode.tap,
                        richMessage: const TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "This is the key you'll pass to the Local Config SDK,\nfor example:\n\n",
                            ),
                            TextSpan(
                              text: 'config.getBoolean("',
                              style: TextStyle(
                                fontFamily: 'monospace',
                              ),
                            ),
                            TextSpan(
                              text: 'config_bool',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '");',
                              style: TextStyle(
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 8,
                          children: [
                            Text(
                              'Parameter name (key)',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const Icon(
                              Icons.help_outline,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                        enabled: false,
                        style: Theme.of(context).textTheme.bodyLarge,
                        initialValue: widget.configName,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data type',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      DropdownMenu(
                        expandedInsets: EdgeInsets.zero,
                        initialSelection: widget.configValue.type.displayName,
                        leadingIcon: Icon(widget.configValue.type.icon),
                        dropdownMenuEntries: ConfigType.values.map((type) {
                          return DropdownMenuEntry<String>(
                            value: type.displayName,
                            label: type.displayName,
                            leadingIcon: Icon(type.icon),
                          );
                        }).toList(),
                        enabled: false,
                        inputDecorationTheme: const InputDecorationTheme(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.only(left: 16, right: 10),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Default value',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      _ConfigValueFormField(
                        configValueController: _configValueController,
                        configValue: widget.configValue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox.square(dimension: 16),
            const Divider(),
            const SizedBox.square(dimension: 8),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: _FormActions(
                formKey: _configFormKey,
                configName: widget.configName,
                configValueTextController: _configValueController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _configValueController.dispose();
    super.dispose();
  }
}

class _ConfigValueFormField extends StatelessWidget {
  const _ConfigValueFormField({
    required this.configValueController,
    required this.configValue,
  });

  final TextEditingController configValueController;
  final Config configValue;

  @override
  Widget build(BuildContext context) {
    final hasPresetValues = configValue.type.presets.isNotEmpty;

    return hasPresetValues
        ? _ConfigValueDropdownButton(
            configValueTextController: configValueController,
            configValueType: configValue.type,
          )
        : _ConfigValueTextField(
            configValueTextController: configValueController,
            configValueType: configValue.type,
          );
  }
}

class _ConfigValueTextField extends StatelessWidget {
  const _ConfigValueTextField({
    required this.configValueTextController,
    required this.configValueType,
  });

  final TextEditingController configValueTextController;
  final ConfigType configValueType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        suffixIcon: configValueType.isText
            ? IconButton(
                onPressed: () async {
                  final newText = await Navigator.of(context).push(
                    MaterialPageRoute<String>(
                      fullscreenDialog: true,
                      builder: (BuildContext context) {
                        return TextEditorScreen(
                          text: configValueTextController.text,
                          controller: configValueType.textEditorController,
                        );
                      },
                    ),
                  );
                  if (!context.mounted) return;
                  configValueTextController.text = newText ?? '';
                },
                icon: const Icon(Icons.open_in_full),
              )
            : null,
      ),
      autovalidateMode: AutovalidateMode.always,
      controller: configValueTextController,
      validator: configValueType.validator,
    );
  }
}

class _ConfigValueDropdownButton extends StatelessWidget {
  const _ConfigValueDropdownButton({
    required this.configValueTextController,
    required this.configValueType,
  });

  final TextEditingController configValueTextController;
  final ConfigType configValueType;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField<String>(
          isDense: false,
          itemHeight: 48,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.only(left: 16, right: 10),
          ),
          items: configValueType.presets.map((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          value: configValueTextController.text,
          validator: configValueType.validator,
          onChanged: (value) => configValueTextController.text = value ?? '',
        ),
      ),
    );
  }
}

class _FormActions extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String configName;
  final TextEditingController configValueTextController;

  const _FormActions({
    required this.formKey,
    required this.configName,
    required this.configValueTextController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        const SizedBox.square(dimension: 8),
        FilledButton(
          onPressed: () {
            if (formKey.currentState?.validate() == false) return;
            ServiceLocator.get<ConfigRepository>().set(
              configName,
              configValueTextController.text,
            );
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

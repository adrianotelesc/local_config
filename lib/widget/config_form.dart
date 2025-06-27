import 'package:local_config/local_config.dart';
import 'package:flutter/material.dart';
import 'package:local_config/screen/text_editor_screen.dart';
import 'package:local_config/extension/build_context_extension.dart';
import 'package:local_config/extension/config_value_extension.dart';
import 'package:local_config/model/config_value.dart';

class _ConfigForm extends StatefulWidget {
  const _ConfigForm({
    required this.configName,
    required this.configValue,
  });

  final String configName;
  final ConfigValue configValue;

  @override
  State<StatefulWidget> createState() => _ConfigFormState();
}

class _ConfigFormState extends State<_ConfigForm> {
  final _configFormKey = GlobalKey<FormState>();
  final _configValueController = TextEditingController();

  String _value = '';

  @override
  void initState() {
    super.initState();
    _value = widget.configValue.asString;
    _configValueController.text = _value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
      child: Form(
        key: _configFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ConfigFormHeader(
              configName: widget.configName,
              configValueType: widget.configValue.type,
            ),
            _ConfigValueFormField(
              configValueController: _configValueController,
              configValue: widget.configValue,
            ),
            _FormActions(
              formKey: _configFormKey,
              configName: widget.configName,
              configValueTextController: _configValueController,
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

class _ConfigFormHeader extends StatelessWidget {
  const _ConfigFormHeader({
    required this.configName,
    required this.configValueType,
  });

  final String configName;
  final ConfigValueType configValueType;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          configName,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(configValueType.icon),
            const SizedBox.square(dimension: 4),
            Text(
              configValueType.name,
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        )
      ],
    );
  }
}

class _ConfigValueFormField extends StatelessWidget {
  const _ConfigValueFormField({
    required this.configValueController,
    required this.configValue,
  });

  final TextEditingController configValueController;
  final ConfigValue configValue;

  @override
  Widget build(BuildContext context) {
    final hasPresetValues = configValue.type.presetValues.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: hasPresetValues
          ? _ConfigValueDropdownButton(
              configValueTextController: configValueController,
              configValueType: configValue.type,
            )
          : _ConfigValueTextField(
              configValueTextController: configValueController,
              configValueType: configValue.type,
            ),
    );
  }
}

class _ConfigValueTextField extends StatelessWidget {
  const _ConfigValueTextField({
    required this.configValueTextController,
    required this.configValueType,
  });

  final TextEditingController configValueTextController;
  final ConfigValueType configValueType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
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
                          delegate: configValueType.editorDelegate,
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
  final ConfigValueType configValueType;

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
          items: configValueType.presetValues.map((value) {
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
  const _FormActions({
    required this.formKey,
    required this.configName,
    required this.configValueTextController,
  });

  final GlobalKey<FormState> formKey;
  final String configName;
  final TextEditingController configValueTextController;

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
            LocalConfig.instance.setString(
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

void showConfigFormModal({
  required BuildContext context,
  required String name,
  required ConfigValue value,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(bottom: context.bottomSheetBottomPadding),
        child: _ConfigForm(configName: name, configValue: value),
      );
    },
  );
}

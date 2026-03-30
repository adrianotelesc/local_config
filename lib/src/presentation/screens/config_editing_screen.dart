import 'package:flutter/material.dart';
import 'package:local_config/src/local_config_internals.dart';
import 'package:local_config/src/presentation/l10n/generated/local_config_localizations.dart';
import 'package:local_config/src/presentation/local_config_theme.dart';
import 'package:local_config/src/presentation/models/config_value.dart';
import 'package:local_config/src/presentation/notifiers/config_notifier.dart';
import 'package:local_config/src/presentation/widgets/input_form_field.dart';
import 'package:local_config/src/presentation/widgets/root_aware_sliver_app_bar.dart';
import 'package:local_config/src/presentation/widgets/text_editor/text_editor.dart';

class ConfigEditingScreen extends StatefulWidget {
  const ConfigEditingScreen({super.key, required this.name});

  final String name;

  @override
  State<StatefulWidget> createState() => _ConfigEditingScreenState();
}

class _ConfigEditingScreenState extends State<ConfigEditingScreen> {
  final _formKey = GlobalKey<FormState>();

  final _textController = TextEditingController();

  final _configNotifier = ConfigNotifier(configRepo: configRepo);

  late ConfigValue _configValue;

  @override
  void initState() {
    super.initState();
    _configValue = _configNotifier.get(widget.name)!;
    _textController.text = _configValue.effectiveValue;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: CustomScrollView(
        slivers: [
          _AppBar(
            onSaveButtonPressed: () => _submit(_textController.text),
          ),
          _Form(
            formKey: _formKey,
            fieldTextController: _textController,
            name: widget.name,
            configValue: _configValue,
            onSubmitted: _submit,
          ),
        ],
      ),
    );
  }

  void _submit(String value) {
    if (_formKey.currentState?.validate() == false) return;
    _configNotifier.set(widget.name, value);
    Navigator.of(context).pop();
  }
}

class _AppBar extends StatelessWidget {
  final Function()? onSaveButtonPressed;

  const _AppBar({
    this.onSaveButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RootAwareSliverAppBar(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      title: Text(LocalConfigLocalizations.of(context)!.editParameter),
      actionsPadding: const EdgeInsets.all(8),
      actions: [
        TextButton(
          onPressed: onSaveButtonPressed,
          child: Text(LocalConfigLocalizations.of(context)!.save),
        ),
      ],
      centerTitle: false,
      pinned: true,
    );
  }
}

class _Form extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fieldTextController;
  final String name;
  final ConfigValue configValue;
  final Function(String)? onSubmitted;

  const _Form({
    required this.formKey,
    required this.fieldTextController,
    required this.name,
    required this.configValue,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverToBoxAdapter(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              InputFormField(
                controller: TextEditingController(text: name),
                textStyle: context.extendedTextTheme.codeBodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(97),
                ),
                label: Tooltip(
                  preferBelow: true,
                  showDuration: const Duration(seconds: 5),
                  triggerMode: TooltipTriggerMode.tap,
                  padding: const EdgeInsets.all(8),
                  richMessage: configValue.type.usageHint(context, name: name),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Text(LocalConfigLocalizations.of(context)!.parameterName),
                      const Icon(Icons.help_outline, size: 16),
                    ],
                  ),
                ),
                enabled: false,
              ),
              InputFormField(
                controller: TextEditingController(
                  text: configValue.type.getDisplayName(context),
                ),
                entries:
                    ConfigValueType.values.map((value) {
                      return DropdownMenuEntry(
                        value: value.getDisplayName(context),
                        label: value.getDisplayName(context),
                        leadingIcon: Icon(value.displayIcon),
                      );
                    }).toList(),
                validator:
                    (value) => configValue.type.validator(context, value ?? ''),
                enabled: false,
                label: Text(
                  LocalConfigLocalizations.of(context)!.dataType,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              InputFormField(
                controller: fieldTextController,
                entries:
                    configValue.type.allowedValues.map((item) {
                      return DropdownMenuEntry(value: item, label: item);
                    }).toList(),
                autofocus: true,
                onFieldSubmitted: onSubmitted,
                validator:
                    (value) => configValue.type.validator(context, value ?? ''),
                textInputAction: TextInputAction.done,
                suffixIcon:
                    configValue.type.isTextBased
                        ? IconButton(
                          onPressed: () async {
                            final changedText = await Navigator.of(
                              context,
                            ).push(
                              MaterialPageRoute<String>(
                                fullscreenDialog: true,
                                builder: (_) {
                                  return TextEditor(
                                    value: fieldTextController.text,
                                    title: LocalConfigLocalizations.of(
                                      context,
                                    )!.editorOf(
                                      configValue.type.getDisplayName(context),
                                    ),
                                    controller:
                                        configValue.type.textEditorController,
                                  );
                                },
                              ),
                            );
                            fieldTextController.text = changedText ?? '';
                          },
                          icon: const Icon(Icons.open_in_full),
                          tooltip:
                              LocalConfigLocalizations.of(
                                context,
                              )!.fullScreenEditor,
                        )
                        : null,
                label: Text(
                  LocalConfigLocalizations.of(context)!.value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

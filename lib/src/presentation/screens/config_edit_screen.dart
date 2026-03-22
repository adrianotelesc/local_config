import 'package:flutter/material.dart';
import 'package:local_config/src/domain/entities/local_config_value.dart';
import 'package:local_config/src/domain/repositories/local_config_repository.dart';
import 'package:local_config/src/local_config_internals.dart';
import 'package:local_config/src/presentation/extensions/config_display_extension.dart';
import 'package:local_config/src/presentation/l10n/generated/local_config_localizations.dart';
import 'package:local_config/src/presentation/local_config_theme.dart';
import 'package:local_config/src/presentation/widgets/input_form_field.dart';
import 'package:local_config/src/presentation/widgets/root_aware_sliver_app_bar.dart';
import 'package:local_config/src/presentation/widgets/text_editor/text_editor.dart';

class ConfigEditScreen extends StatefulWidget {
  const ConfigEditScreen({super.key, required this.name});

  final String name;

  @override
  State<StatefulWidget> createState() => _ConfigEditScreenState();
}

class _ConfigEditScreenState extends State<ConfigEditScreen> {
  final _configRepo = configRepository;

  final _formKey = GlobalKey<FormState>();

  final _textController = TextEditingController();

  late LocalConfigValue _configValue;

  @override
  void initState() {
    super.initState();
    _configValue = _configRepo.configs[widget.name]!;
    _textController.text = _configValue.asString;
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
            formKey: _formKey,
            name: widget.name,
            textController: _textController,
            configRepo: _configRepo,
          ),
          _Form(
            formKey: _formKey,
            name: widget.name,
            textController: _textController,
            configRepo: _configRepo,
            configValue: _configValue,
          ),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final LocalConfigRepository configRepo;
  final GlobalKey<FormState> formKey;
  final TextEditingController textController;
  final String name;

  const _AppBar({
    required this.configRepo,
    required this.formKey,
    required this.textController,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return RootAwareSliverAppBar(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      title: Text(LocalConfigLocalizations.of(context)!.editParameter),
      actionsPadding: const EdgeInsets.all(8),
      actions: [
        TextButton(
          onPressed: () {
            if (formKey.currentState?.validate() == false) return;
            configRepo.set(name, textController.text);
            Navigator.of(context).pop();
          },
          child: Text(LocalConfigLocalizations.of(context)!.save),
        ),
      ],
      centerTitle: false,
      pinned: true,
    );
  }
}

class _Form extends StatelessWidget {
  final LocalConfigRepository configRepo;
  final GlobalKey<FormState> formKey;
  final TextEditingController textController;
  final String name;
  final LocalConfigValue configValue;

  const _Form({
    required this.configRepo,
    required this.formKey,
    required this.textController,
    required this.name,
    required this.configValue,
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
                  richMessage: configValue.type.help(context, name: name),
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
                    LocalConfigType.values.map((value) {
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
                controller: textController,
                entries:
                    configValue.type.presets.map((item) {
                      return DropdownMenuEntry(value: item, label: item);
                    }).toList(),
                autofocus: true,
                onFieldSubmitted: (_) {
                  if (formKey.currentState?.validate() == false) return;
                  configRepo.set(name, textController.text);
                  Navigator.of(context).pop();
                },
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
                                    value: textController.text,
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
                            textController.text = changedText ?? '';
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

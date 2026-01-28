import 'package:flutter/material.dart';
import 'package:local_config/src/core/di/service_locator.dart';
import 'package:local_config/src/domain/repository/config_repository.dart';
import 'package:local_config/src/ui/extension/config_display_extension.dart';
import 'package:local_config/src/domain/entity/config.dart';
import 'package:local_config/src/ui/l10n/local_config_localizations.dart';
import 'package:local_config/src/ui/widget/root_aware_sliver_app_bar.dart';
import 'package:local_config/src/ui/widget/text_editor/text_editor.dart';
import 'package:local_config/src/ui/widget/input_form_field.dart';
import 'package:provider/provider.dart';

class ConfigEditPage extends StatefulWidget {
  final String name;

  const ConfigEditPage({super.key, required this.name});

  @override
  State<StatefulWidget> createState() => _ConfigEditPageState();
}

class _ConfigEditPageState extends State<ConfigEditPage> {
  final _controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late final ConfigRepository _repo;

  late ConfigValue _config;

  @override
  void initState() {
    super.initState();
    _repo = context.read<ServiceLocator>().get<ConfigRepository>();
    _config = _repo.configs[widget.name]!;
    _controller.text = _config.value.toString();
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
            controller: _controller,
            repo: _repo,
          ),
          _Form(
            formKey: _formKey,
            name: widget.name,
            config: _config,
            controller: _controller,
            repo: _repo,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _AppBar extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String name;
  final TextEditingController controller;
  final ConfigRepository repo;

  const _AppBar({
    required this.formKey,
    required this.name,
    required this.controller,
    required this.repo,
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
            repo.set(name, controller.text);
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
  final GlobalKey<FormState> formKey;
  final String name;
  final ConfigValue config;
  final TextEditingController controller;
  final ConfigRepository repo;

  const _Form({
    required this.formKey,
    required this.name,
    required this.config,
    required this.controller,
    required this.repo,
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
                label: Tooltip(
                  preferBelow: true,
                  showDuration: const Duration(seconds: 5),
                  triggerMode: TooltipTriggerMode.tap,
                  padding: const EdgeInsets.all(8),
                  richMessage: config.type.help(context, name: name),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Text(
                        LocalConfigLocalizations.of(context)!.parameterName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Icon(Icons.help_outline, size: 16),
                    ],
                  ),
                ),
                enabled: false,
              ),
              InputFormField(
                controller: TextEditingController(
                  text: config.type.getDisplayName(context),
                ),
                entries:
                    ConfigType.values.map((value) {
                      return DropdownMenuEntry(
                        value: value.getDisplayName(context),
                        label: value.getDisplayName(context),
                        leadingIcon: Icon(value.icon),
                      );
                    }).toList(),
                validator: (value) => config.type.validator(context, value),
                enabled: false,
                label: Text(
                  LocalConfigLocalizations.of(context)!.dataType,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              InputFormField(
                controller: controller,
                entries:
                    config.type.presets.map((item) {
                      return DropdownMenuEntry(value: item, label: item);
                    }).toList(),
                autofocus: true,
                onFieldSubmitted: (_) {
                  if (formKey.currentState?.validate() == false) return;
                  repo.set(name, controller.text);
                  Navigator.of(context).pop();
                },
                validator: (value) => config.type.validator(context, value),
                textInputAction: TextInputAction.done,
                suffixIcon:
                    config.type.isText
                        ? IconButton(
                          onPressed: () async {
                            final changedText = await Navigator.of(
                              context,
                            ).push(
                              MaterialPageRoute<String>(
                                fullscreenDialog: true,
                                builder: (_) {
                                  return TextEditor(
                                    value: controller.text,
                                    title: LocalConfigLocalizations.of(
                                      context,
                                    )!.editorOf(
                                      config.type.getDisplayName(context),
                                    ),
                                    controller:
                                        config.type.textEditorController,
                                  );
                                },
                              ),
                            );
                            controller.text = changedText ?? '';
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

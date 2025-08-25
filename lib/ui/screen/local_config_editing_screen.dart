import 'package:flutter/material.dart';
import 'package:local_config/di/service_locator.dart';
import 'package:local_config/repository/config_repository.dart';
import 'package:local_config/extension/config_extension.dart';
import 'package:local_config/model/config.dart';
import 'package:local_config/ui/widget/text_editor/text_editor.dart';
import 'package:local_config/ui/theming/theme.dart';
import 'package:local_config/ui/widget/input_form_field.dart';

class LocalConfigEditingScreen extends StatefulWidget {
  final String name;

  const LocalConfigEditingScreen({
    super.key,
    required this.name,
  });

  @override
  State<StatefulWidget> createState() => _LocalConfigEditingScreenState();
}

class _LocalConfigEditingScreenState extends State<LocalConfigEditingScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _repo = ServiceLocator.locate<ConfigRepository>();

  late Config _config;

  @override
  void initState() {
    super.initState();
    _config = _repo.configs[widget.name]!;
    _controller.text = _config.value;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: defaultTheme,
      child: Scaffold(
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
    return SliverAppBar(
      title: const Text('Edit parameter'),
      actionsPadding: const EdgeInsets.all(8),
      actions: [
        TextButton(
          onPressed: () {
            if (formKey.currentState?.validate() == false) return;
            repo.set(name, controller.text);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
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
  final Config config;
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
                controller: TextEditingController(
                  text: name,
                ),
                label: Tooltip(
                  preferBelow: false,
                  showDuration: const Duration(seconds: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inverseSurface,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  triggerMode: TooltipTriggerMode.tap,
                  richMessage: config.type.help(name: name),
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
                enabled: false,
              ),
              InputFormField(
                controller: TextEditingController(
                  text: config.type.displayName,
                ),
                entries: ConfigType.values.map((value) {
                  return DropdownMenuEntry(
                    value: value.displayName,
                    label: value.displayName,
                    leadingIcon: Icon(value.icon),
                  );
                }).toList(),
                validator: config.type.validator,
                enabled: false,
                label: Text(
                  'Data type',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              InputFormField(
                controller: controller,
                entries: config.type.presets.map((item) {
                  return DropdownMenuEntry(
                    value: item,
                    label: item,
                  );
                }).toList(),
                autofocus: true,
                onFieldSubmitted: (_) {
                  if (formKey.currentState?.validate() == false) return;
                  repo.set(name, controller.text);
                  Navigator.of(context).pop();
                },
                validator: config.type.validator,
                textInputAction: TextInputAction.done,
                suffixIcon: config.type.isText
                    ? IconButton(
                        onPressed: () async {
                          final changedText = await Navigator.of(context).push(
                            MaterialPageRoute<String>(
                              fullscreenDialog: true,
                              builder: (_) {
                                return TextEditor(
                                  text: controller.text,
                                  controller: config.type.textEditorController,
                                );
                              },
                            ),
                          );
                          controller.text = changedText ?? '';
                        },
                        icon: const Icon(Icons.open_in_full),
                      )
                    : null,
                label: Text(
                  'Value',
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

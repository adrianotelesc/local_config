import 'dart:async';

import 'package:flutter/material.dart';
import 'package:local_config/di/service_locator.dart';
import 'package:local_config/common/extension/map_extension.dart';
import 'package:local_config/common/extension/string_extension.dart';
import 'package:local_config/domain/repository/config_repository.dart';
import 'package:local_config/ui/theming/styles.dart';
import 'package:local_config/common/extension/config_extension.dart';
import 'package:local_config/ui/theming/theme.dart';
import 'package:local_config/ui/widget/animated_floating_text.dart';
import 'package:local_config/ui/widget/callout.dart';
import 'package:local_config/ui/screen/local_config_editing_screen.dart';
import 'package:local_config/domain/model/config.dart';
import 'package:local_config/ui/widget/extended_list_tile.dart';
import 'package:local_config/ui/widget/clearable_search_bar.dart';
import 'package:local_config/ui/widget/message.dart';
import 'package:local_config/ui/widget/animated_jitter_text.dart';

class LocalConfigListScreen extends StatefulWidget {
  const LocalConfigListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LocalConfigListScreenState();
}

class _LocalConfigListScreenState extends State<LocalConfigListScreen> {
  final _controller = TextEditingController();

  final _repo = ServiceLocator.locate<ConfigRepository>();

  StreamSubscription? _sub;

  var _configs = <String, Config>{};

  var _items = <(String, Config)>[];

  var _hasOverrides = false;

  @override
  void initState() {
    super.initState();
    _updateConfigs(_repo.configs);
    _controller.addListener(_updateItems);
    _sub = _repo.configsStream.listen(_updateConfigs);
  }

  void _updateConfigs(Map<String, Config> configs) {
    _configs = configs;
    _updateItems();
    _updateOverrides();
  }

  void _updateItems() {
    final query = _controller.text;
    final filtered = _configs.whereKey((key) {
      return query.trim().isEmpty || key.containsInsensitive(query);
    });
    final items = filtered.records;
    setState(() => _items = items);
  }

  void _updateOverrides() {
    final hasOverrides = _configs.anyValue((config) => config.isOverridden);
    if (hasOverrides == _hasOverrides) return;
    setState(() => _hasOverrides = hasOverrides);
  }

  @override
  void dispose() {
    _sub?.cancel();
    _sub = null;
    _controller.removeListener(_updateItems);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: defaultTheme,
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                _AppBar(
                  hasOverrides: _hasOverrides,
                  repo: _repo,
                ),
                if (_configs.isEmpty)
                  const _SetupMessage()
                else ...[
                  _SearchBar(
                    controller: _controller,
                  ),
                  _List(
                    items: _items,
                    repo: _repo,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final bool hasOverrides;
  final ConfigRepository repo;

  const _AppBar({
    required this.hasOverrides,
    required this.repo,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: const Text('Local Config'),
      centerTitle: false,
      floating: true,
      pinned: true,
      bottom: hasOverrides
          ? PreferredSize(
              preferredSize: const Size.fromHeight(
                Callout.defaultHeight,
              ),
              child: Callout.warning(
                icon: Icons.error,
                text: 'Configs changed locally',
                trailing: TextButton(
                  onPressed: repo.resetAll,
                  style: warningButtonStyle(context),
                  child: const Text('Reset all'),
                ),
              ),
            )
          : null,
    );
  }
}

class _SetupMessage extends StatelessWidget {
  const _SetupMessage();

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Message(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        spacing: 24,
        header: AnimatedJitterText(
          'WHERE ARE THE CONFIGS!?',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        body: Text(
          '''Hmm... this might be happening because:
• Local Config SDK hasn’t been initialized yet.
• Configs are still populating.''',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        footer: AnimatedFloatingText(
          'If you\'ve been waiting a while, maybe your configs are... empty.',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;

  const _SearchBar({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: ClearableSearchBar(
          controller: controller,
          hintText: 'Search',
        ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  final List<(String, Config)> items;
  final ConfigRepository repo;

  const _List({
    required this.items,
    required this.repo,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Message(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          body: AnimatedFloatingText(
            'Uuuh... Nothing here... Just emptiness...',
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
      );
    }

    return SliverList.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, index) {
        final (name, config) = items[index];
        final isOverridden = config.isOverridden;

        return ExtendedListTile(
          leading: Icon(config.type.icon),
          style: isOverridden
              ? warningExtendedListTileStyle(context) //
              : null,
          title: Text(name),
          subtitle: Text(
            config.displayText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          top: isOverridden
              ? Callout.warning(
                  style: CalloutStyle(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  icon: Icons.error,
                  text: 'Locally changed',
                  trailing: TextButton(
                    onPressed: () => repo.reset(name),
                    style: warningButtonStyle(context),
                    child: const Text('Reset'),
                  ),
                )
              : null,
          trailing: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (_) {
                    return LocalConfigEditingScreen(
                      name: name,
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        );
      },
    );
  }
}

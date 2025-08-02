import 'dart:async';

import 'package:flutter/material.dart';
import 'package:local_config/di/service_locator.dart';
import 'package:local_config/extension/map_extension.dart';
import 'package:local_config/extension/string_extension.dart';
import 'package:local_config/repository/config_repository.dart';
import 'package:local_config/ui/theming/styles.dart';
import 'package:local_config/extension/config_extension.dart';
import 'package:local_config/ui/theming/theme.dart';
import 'package:local_config/ui/widget/callout.dart';
import 'package:local_config/ui/widget/config_form.dart';
import 'package:local_config/model/config.dart';
import 'package:local_config/ui/widget/extended_list_tile.dart';
import 'package:local_config/ui/widget/clearable_search_bar.dart';
import 'package:local_config/ui/widget/feedback_view.dart';

class LocalConfigScreen extends StatefulWidget {
  const LocalConfigScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LocalConfigScreenState();
}

class _LocalConfigScreenState extends State<LocalConfigScreen> {
  final _controller = TextEditingController();

  final _repo = ServiceLocator.get<ConfigRepository>();

  StreamSubscription? _populateSub;

  StreamSubscription? _configsSub;

  var _populateStatus = PopulateStatus.notStarted;

  var _configs = <String, Config>{};

  var _items = <(String, Config)>[];

  var _hasOverrides = false;

  @override
  void initState() {
    super.initState();
    _populateStatus = _repo.populateStatus;
    _applyConfigs(_repo.configs);
    _controller.addListener(_updateItems);
    _populateSub = _repo.populateStatusStream.listen(_applyPopulateStatus);
    _configsSub = _repo.configsStream.listen(_applyConfigs);
  }

  void _applyPopulateStatus(PopulateStatus populateStatus) {
    setState(() {
      _populateStatus = populateStatus;
    });
  }

  void _applyConfigs(Map<String, Config> configs) {
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
    _populateSub?.cancel();
    _populateSub = null;
    _configsSub?.cancel();
    _configsSub = null;
    _controller.removeListener(_updateItems);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: defaultTheme,
      child: Builder(builder: (context) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _AppBar(
                hasOverrides: _hasOverrides,
                repo: _repo,
              ),
              _SearchBar(
                controller: _controller,
              ),
              switch (_populateStatus) {
                PopulateStatus.notStarted => const SliverFillRemaining(
                    hasScrollBody: false,
                    child: FeedbackView(
                      title: '( ╹ -╹)',
                      message: 'You have\'nt initialized.',
                    ),
                  ),
                PopulateStatus.inProgress => const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                PopulateStatus.completed => _List(
                    items: _items,
                    repo: _repo,
                  ),
              }
            ],
          ),
        );
      }),
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
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: FeedbackView(
          title: '( ╹ -╹)',
          message: 'There is nothing here.',
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
              ConfigForm.showAsBottomSheet(
                context: context,
                name: name,
                value: config,
              );
            },
            icon: const Icon(Icons.edit),
          ),
        );
      },
    );
  }
}

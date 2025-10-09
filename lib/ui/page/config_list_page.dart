import 'dart:async';

import 'package:flutter/material.dart';
import 'package:local_config/common/extension/map_extension.dart';
import 'package:local_config/common/extension/string_extension.dart';
import 'package:local_config/core/di/service_locator.dart';
import 'package:local_config/domain/repository/config_repository.dart';
import 'package:local_config/ui/l10n/local_config_localizations.dart';
import 'package:local_config/ui/local_config_routes.dart';
import 'package:local_config/ui/theming/styles.dart';
import 'package:local_config/ui/extension/config_display_extension.dart';
import 'package:local_config/ui/theming/theme.dart';
import 'package:local_config/ui/widget/callout.dart';
import 'package:local_config/domain/model/config.dart';
import 'package:local_config/ui/widget/extended_list_tile.dart';
import 'package:local_config/ui/widget/clearable_search_bar.dart';
import 'package:provider/provider.dart';

class ConfigListPage extends StatefulWidget {
  const ConfigListPage({super.key});

  @override
  State<StatefulWidget> createState() => _ConfigListPageState();
}

class _ConfigListPageState extends State<ConfigListPage> {
  final _controller = TextEditingController();

  late final ConfigRepository _repo;

  StreamSubscription? _sub;

  var _configs = <String, Config>{};

  var _items = <(String, Config)>[];

  var _hasOverrides = false;

  @override
  void initState() {
    super.initState();
    _repo = context.read<ServiceLocator>().get<ConfigRepository>();
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
                  const _PendingStatusNotice()
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
      title: Text(LocalConfigLocalizations.of(context)!.localConfig),
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
                text: LocalConfigLocalizations.of(
                  context,
                )!.changesApplied,
                trailing: TextButton(
                  onPressed: repo.resetAll,
                  style: warningButtonStyle(context),
                  child: Text(
                    LocalConfigLocalizations.of(context)!.revertAll,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

class _PendingStatusNotice extends StatelessWidget {
  const _PendingStatusNotice();

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            Text(
              LocalConfigLocalizations.of(context)!.noConfigsQuestion,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: LocalConfigLocalizations.of(
                      context,
                    )!.possibleCauses,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const TextSpan(text: '\n\n'),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: LocalConfigLocalizations.of(
                          context,
                        )!.uninitializedTitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: LocalConfigLocalizations.of(
                          context,
                        )!.uninitializedDescription,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const TextSpan(text: '\n\n'),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: LocalConfigLocalizations.of(
                          context,
                        )!.emptyConfigsTitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: LocalConfigLocalizations.of(
                          context,
                        )!.emptyConfigsDescription,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const TextSpan(text: '\n\n'),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: LocalConfigLocalizations.of(
                          context,
                        )!.loadingConfigsTitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: LocalConfigLocalizations.of(
                          context,
                        )!.loadingConfigsDescription,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const TextSpan(text: '\n\n'),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: LocalConfigLocalizations.of(
                          context,
                        )!.openGitHubIssue,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
          hintText: LocalConfigLocalizations.of(context)!.search,
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
      // TODO: Improve this message.
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Text(
                LocalConfigLocalizations.of(context)!.noResults,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ],
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
            config.getDisplayText(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          top: isOverridden
              ? Callout.warning(
                  style: CalloutStyle(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  icon: Icons.error,
                  text: LocalConfigLocalizations.of(context)!.changed,
                  trailing: TextButton(
                    onPressed: () => repo.reset(name),
                    style: warningButtonStyle(context),
                    child: Text(LocalConfigLocalizations.of(context)!.revert),
                  ),
                )
              : null,
          trailing: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                LocalConfigRoutes.configEdit,
                arguments: name,
              );
            },
            icon: const Icon(Icons.edit),
          ),
        );
      },
    );
  }
}

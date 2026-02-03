import 'dart:async';

import 'package:boxy/slivers.dart';
import 'package:flutter/material.dart';
import 'package:local_config/src/common/extension/map_extension.dart';
import 'package:local_config/src/common/extension/string_extension.dart';
import 'package:local_config/src/core/di/service_locator.dart';
import 'package:local_config/src/domain/repository/config_repository.dart';
import 'package:local_config/src/ui/l10n/local_config_localizations.dart';
import 'package:local_config/src/ui/local_config_routes.dart';
import 'package:local_config/src/ui/local_config_theme.dart';
import 'package:local_config/src/ui/extension/config_display_extension.dart';
import 'package:local_config/src/ui/widget/callout.dart';
import 'package:local_config/src/domain/entity/config.dart';
import 'package:local_config/src/ui/widget/extended_list_tile.dart';
import 'package:local_config/src/ui/widget/clearable_search_bar.dart';
import 'package:local_config/src/ui/widget/root_aware_sliver_app_bar.dart';
import 'package:provider/provider.dart';

class ConfigListPage extends StatefulWidget {
  const ConfigListPage({super.key});

  @override
  State<StatefulWidget> createState() => _ConfigListPageState();
}

class _ConfigListPageState extends State<ConfigListPage> {
  static const _backToTopScrollOffsetThreshould = 200.0;

  final _focusNode = FocusNode();

  final _textController = TextEditingController();

  final _scrollController = ScrollController();

  late final ConfigRepository _repo;

  StreamSubscription? _sub;

  var showOnlyChanged = false;

  var _configs = <String, ConfigValue>{};

  var _items = <(String, ConfigValue)>[];

  var _hasOverrides = false;

  var _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _repo = context.read<ServiceLocator>().get<ConfigRepository>();
    _updateConfigs(_repo.configs);
    _textController.addListener(_updateItems);
    _sub = _repo.configsStream.listen(_updateConfigs);
    _scrollController.addListener(_updateBackToTop);
  }

  void _updateBackToTop() {
    final shouldShowBackToTop =
        _scrollController.offset > _backToTopScrollOffsetThreshould;

    if (shouldShowBackToTop && !_showBackToTop) {
      setState(() => _showBackToTop = true);
    } else if (!shouldShowBackToTop && _showBackToTop) {
      setState(() => _showBackToTop = false);
    }
  }

  void _updateConfigs(Map<String, ConfigValue> configs) {
    _configs = configs;
    _updateItems();
    _updateOverrides();
  }

  void _updateItems() {
    final query = _textController.text
        .split(RegExp(r'\s+'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty);
    final filtered = _configs.where((key, value) {
      return (!showOnlyChanged || value.isOverridden) &&
          (query.isEmpty ||
              query.any((q) => key.containsInsensitive(q)) ||
              query.any((q) => value.raw.containsInsensitive(q)));
    });
    final items = filtered.toRecordList();
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
    _textController.removeListener(_updateItems);
    _scrollController.removeListener(_updateBackToTop);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AnimatedSlide(
        offset: _showBackToTop ? Offset.zero : Offset(0, 5),
        duration: Durations.long1,
        child: FloatingActionButton.small(
          onPressed: () {
            _scrollController.animateTo(
              0,
              duration: Durations.medium1,
              curve: Curves.easeInOut,
            );
          },
          child: const Icon(Icons.keyboard_arrow_up),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _AppBar(hasOverrides: _hasOverrides, repo: _repo),
          if (_configs.isEmpty)
            const _PendingStatusNotice()
          else ...[
            SliverToBoxAdapter(child: SizedBox.square(dimension: 16)),
            _SearchBar(controller: _textController, focusNode: _focusNode),
            SliverToBoxAdapter(child: SizedBox.square(dimension: 8)),
            SliverToBoxAdapter(
              child: SwitchListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 0,
                ),
                title: Text(
                  LocalConfigLocalizations.of(context).showChangesOnly,
                ),
                value: showOnlyChanged,
                onChanged: (value) {
                  setState(() {
                    showOnlyChanged = value;
                  });

                  _updateItems();
                },
              ),
            ),
            SliverToBoxAdapter(child: SizedBox.square(dimension: 8)),
            _List(items: _items, repo: _repo),
          ],
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final bool hasOverrides;
  final ConfigRepository repo;

  const _AppBar({required this.hasOverrides, required this.repo});

  @override
  Widget build(BuildContext context) {
    return RootAwareSliverAppBar(
      title: Image.asset(
        'assets/images/logo.png',
        package: 'local_config',
        height: 24,
      ),
      titleSpacing: 0,
      floating: true,
      pinned: true,
      bottom:
          hasOverrides
              ? PreferredSize(
                preferredSize: const Size.fromHeight(Callout.defaultHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Callout.warning(
                    icon: Icons.error,
                    style: CalloutStyle(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    text: LocalConfigLocalizations.of(context).changesApplied,
                    trailing: TextButton(
                      onPressed: repo.clear,
                      style: warningButtonStyle(context),
                      child: Text(
                        LocalConfigLocalizations.of(context).revertAll,
                      ),
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
              LocalConfigLocalizations.of(context).noConfigsQuestion,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: LocalConfigLocalizations.of(context).possibleCauses,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const TextSpan(text: '\n\n'),
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            LocalConfigLocalizations.of(
                              context,
                            ).uninitializedTitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text:
                            LocalConfigLocalizations.of(
                              context,
                            ).uninitializedDescription,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const TextSpan(text: '\n\n'),
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            LocalConfigLocalizations.of(
                              context,
                            ).emptyConfigsTitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text:
                            LocalConfigLocalizations.of(
                              context,
                            ).emptyConfigsDescription,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const TextSpan(text: '\n\n'),
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            LocalConfigLocalizations.of(
                              context,
                            ).loadingConfigsTitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text:
                            LocalConfigLocalizations.of(
                              context,
                            ).loadingConfigsDescription,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const TextSpan(text: '\n\n'),
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            LocalConfigLocalizations.of(
                              context,
                            ).openGitHubIssue,
                        style: Theme.of(context).textTheme.bodyMedium,
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
  final FocusNode focusNode;
  final TextEditingController controller;

  const _SearchBar({required this.controller, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ClearableSearchBar(
          controller: controller,
          focusNode: focusNode,
          hintText: LocalConfigLocalizations.of(context).search,
        ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  final List<(String, ConfigValue)> items;
  final ConfigRepository repo;

  const _List({required this.items, required this.repo});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(left: 12, right: 12, bottom: 128),
      sliver: SliverContainer(
        background: ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
        ),
        borderRadius: BorderRadius.circular(16),
        sliver: SliverMainAxisGroup(
          slivers: [
            if (items.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                sliver: SliverToBoxAdapter(
                  child: Text(LocalConfigLocalizations.of(context).noResults),
                ),
              ),
            if (items.isNotEmpty)
              SliverList.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, index) {
                  final (name, config) = items[index];
                  final isOverridden = config.isOverridden;

                  return ExtendedListTile(
                    leading: Icon(config.type.icon),
                    style:
                        isOverridden
                            ? warningExtendedListTileStyle(context) //
                            : null,
                    title: Text(name),
                    subtitle: Text(
                      config.getDisplayText(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    top:
                        isOverridden
                            ? Callout.warning(
                              style: CalloutStyle(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              icon: Icons.error,
                              text:
                                  LocalConfigLocalizations.of(context).changed,
                              trailing: TextButton(
                                onPressed: () => repo.remove(name),
                                style: warningButtonStyle(context),
                                child: Text(
                                  LocalConfigLocalizations.of(context).revert,
                                ),
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
                      tooltip: LocalConfigLocalizations.of(context).edit,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

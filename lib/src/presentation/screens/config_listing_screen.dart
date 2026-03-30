import 'package:boxy/slivers.dart';
import 'package:flutter/material.dart';
import 'package:local_config/src/local_config.dart';
import 'package:local_config/src/local_config_internals.dart';
import 'package:local_config/src/presentation/l10n/generated/local_config_localizations.dart';
import 'package:local_config/src/presentation/local_config_routes.dart';
import 'package:local_config/src/presentation/local_config_theme.dart';
import 'package:local_config/src/presentation/models/config_value.dart';
import 'package:local_config/src/presentation/notifiers/config_notifier.dart';
import 'package:local_config/src/presentation/widgets/back_to_top_fab.dart';
import 'package:local_config/src/presentation/widgets/callout.dart';
import 'package:local_config/src/presentation/widgets/clearable_search_bar.dart';
import 'package:local_config/src/presentation/widgets/extended_list_tile.dart';
import 'package:local_config/src/presentation/widgets/root_aware_sliver_app_bar.dart';

class ConfigListingScreen extends StatefulWidget {
  const ConfigListingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ConfigListingScreenState();
}

class _ConfigListingScreenState extends State<ConfigListingScreen> {
  final _textController = TextEditingController();

  final _scrollController = ScrollController();

  final _configNotifier = ConfigNotifier(configRepo: configRepo);

  @override
  void initState() {
    super.initState();
    _textController.addListener(_query);
  }

  void _query() {
    _configNotifier.query(_textController.text);
  }

  @override
  void dispose() {
    _textController.removeListener(_query);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: BackToTopFab(controller: _scrollController),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ListenableBuilder(
        listenable: _configNotifier,
        builder: (context, child) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              _AppBar(
                hasOverrides: _configNotifier.hasLocalValue,
                onResetAllTap: _configNotifier.resetAll,
              ),
              if (_configNotifier.all.isEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      LocalConfig.instance.initialized
                          ? LocalConfigLocalizations.of(context)!.noConfigs
                          : LocalConfigLocalizations.of(context)!.uninitialized,
                    ),
                  ),
                )
              else ...[
                SliverToBoxAdapter(child: SizedBox.square(dimension: 16)),
                _SearchBar(controller: _textController),
                SliverToBoxAdapter(child: SizedBox.square(dimension: 8)),
                SliverToBoxAdapter(
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                    title: Text(
                      LocalConfigLocalizations.of(context)!.showOnlyChanged,
                    ),
                    value: _configNotifier.showOnlyLocals,
                    onChanged: (value) {
                      _configNotifier.showOnlyLocals = value;
                    },
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox.square(dimension: 8)),
                _List(
                  items: _configNotifier.filtered,
                  terms: _configNotifier.terms,
                  onResetTap: _configNotifier.reset,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final bool hasOverrides;
  final Function()? onResetAllTap;

  const _AppBar({
    required this.hasOverrides,
    this.onResetAllTap,
  });

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
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Callout.warning(
                    icon: Icons.error,
                    style: CalloutStyle(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    text: LocalConfigLocalizations.of(context)!.changesApplied,
                    trailing: TextButton(
                      onPressed: onResetAllTap,
                      style: warningButtonStyle(context),
                      child: Text(
                        LocalConfigLocalizations.of(context)!.revertAll,
                      ),
                    ),
                  ),
                ),
              )
              : null,
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;

  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ClearableSearchBar(
          controller: controller,
          hintText: LocalConfigLocalizations.of(context)!.search,
        ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  final Set<String> terms;
  final List<MapEntry<String, ConfigValue>> items;
  final Function(String)? onResetTap;

  const _List({
    required this.items,
    this.terms = const {},
    this.onResetTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 128),
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
                  child: Text(LocalConfigLocalizations.of(context)!.noResults),
                ),
              ),
            if (items.isNotEmpty)
              SliverList.separated(
                itemCount: items.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (_, index) {
                  final item = items[index];
                  final (name, config) = (item.key, item.value);
                  final hasOverride = config.hasOverride;

                  return ExtendedListTile(
                    leading: Icon(config.type.displayIcon),
                    style:
                        hasOverride
                            ? warningExtendedListTileStyle(context) //
                            : null,
                    title: Text.rich(
                      highlightTerms(
                        text: name,
                        terms: terms,
                        normalStyle: context.extendedTextTheme.codeBodyMedium
                            ?.copyWith(
                              fontWeight: hasOverride ? FontWeight.bold : null,
                            ),
                        highlightStyle: context.extendedTextTheme.codeBodyMedium
                            ?.copyWith(
                              fontWeight: hasOverride ? FontWeight.bold : null,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary.withAlpha(102),
                            ),
                      ),
                      style: context.extendedTextTheme.codeBodyMedium?.copyWith(
                        fontWeight: hasOverride ? FontWeight.bold : null,
                      ),
                    ),
                    subtitle: Text.rich(
                      highlightTerms(
                        text: config.getDisplayText(context),
                        terms: terms,
                        normalStyle: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: hasOverride ? FontWeight.bold : null,
                        ),
                        highlightStyle: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: hasOverride ? FontWeight.bold : null,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary.withAlpha(102),
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: hasOverride ? FontWeight.bold : null,
                      ),
                    ),
                    top:
                        hasOverride
                            ? Callout.warning(
                              style: CalloutStyle(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              icon: Icons.error,
                              text:
                                  LocalConfigLocalizations.of(context)!.changed,
                              trailing: TextButton(
                                onPressed: () => onResetTap?.call(name),
                                style: warningButtonStyle(context),
                                child: Text(
                                  LocalConfigLocalizations.of(context)!.revert,
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
                      tooltip: LocalConfigLocalizations.of(context)!.edit,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  TextSpan highlightTerms({
    required String text,
    required Set<String> terms,
    TextStyle? normalStyle,
    TextStyle? highlightStyle,
  }) {
    if (terms.isEmpty) {
      return TextSpan(text: text, style: normalStyle);
    }

    final escaped = terms.map(RegExp.escape);
    final pattern = RegExp('(${escaped.join('|')})', caseSensitive: false);

    final matches = pattern.allMatches(text);

    if (matches.isEmpty) {
      return TextSpan(text: text, style: normalStyle);
    }

    final spans = <TextSpan>[];
    int start = 0;

    for (final match in matches) {
      if (match.start > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, match.start),
            style: normalStyle,
          ),
        );
      }

      spans.add(TextSpan(text: match.group(0), style: highlightStyle));

      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: normalStyle));
    }

    return TextSpan(children: spans);
  }
}

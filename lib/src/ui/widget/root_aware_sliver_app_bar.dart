import 'package:flutter/material.dart';

class RootAwareSliverAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Widget title;
  final Color? backgroundColor;
  final bool centerTitle;
  final bool floating;
  final bool pinned;
  final EdgeInsetsGeometry? actionsPadding;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const RootAwareSliverAppBar({
    super.key,
    required this.title,
    this.backgroundColor,
    this.centerTitle = false,
    this.floating = false,
    this.pinned = false,
    this.actions,
    this.actionsPadding,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedNavigator = _resolveNavigator(context);
    final route = ModalRoute.of(context);

    final canPop = resolvedNavigator.canPop();
    final isFullscreenDialog = (route is PageRoute && route.fullscreenDialog);

    Widget? leading;
    if (canPop) {
      leading =
          isFullscreenDialog
              ? CloseButton(onPressed: () => resolvedNavigator.maybePop())
              : BackButton(onPressed: () => resolvedNavigator.maybePop());
    }

    return SliverAppBar(
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      leading: leading,
      title: title,
      centerTitle: centerTitle,
      floating: floating,
      pinned: pinned,
      actions: actions,
      bottom: bottom,
      actionsPadding: actionsPadding,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

NavigatorState _resolveNavigator(BuildContext context) {
  final route = ModalRoute.of(context);
  final local = Navigator.of(context);
  final root = Navigator.of(context, rootNavigator: true);

  final isInitialRoute = route?.isFirst ?? true;
  final canPopLocal = local.canPop();

  if (canPopLocal) return local;
  if (isInitialRoute && root.canPop()) return root;
  return local;
}

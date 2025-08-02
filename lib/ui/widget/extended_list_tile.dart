import 'package:flutter/material.dart';

class ExtendedListTile extends StatelessWidget {
  final ExtendedListTileStyle? style;
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final Widget? top;

  const ExtendedListTile({
    super.key,
    this.style,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.top,
  });

  @override
  Widget build(BuildContext context) {
    final tileColor = style?.tileColor;

    return Column(
      children: [
        if (top != null)
          Container(
            padding: const EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
            ),
            color: tileColor,
            child: top,
          ),
        ListTile(
          leading: leading,
          title: title,
          titleTextStyle: style?.titleTextStyle,
          subtitle: subtitle,
          subtitleTextStyle: style?.subtitleTextStyle,
          trailing: trailing,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          tileColor: tileColor,
        )
      ],
    );
  }
}

class ExtendedListTileStyle {
  final Color? tileColor;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;

  const ExtendedListTileStyle({
    this.tileColor,
    this.titleTextStyle,
    this.subtitleTextStyle,
  });
}

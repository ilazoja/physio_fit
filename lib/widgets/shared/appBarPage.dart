import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AppBarPage extends StatelessWidget implements PreferredSizeWidget {
  // Can decrease app bar height via preferredSize
  AppBarPage(
      {Key key,
      this.title,
      this.titleWidget,
      this.action,
      this.brightness,
      this.elevation,
      this.backgroundColor,
      this.showBackButton})
      : preferredSize = Size.fromHeight(50),
        super(key: key);

  String title;
  Widget titleWidget;
  final IconButton action;
  final Brightness brightness;
  final double elevation;
  final Color backgroundColor;
  bool showBackButton;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    title ??= '';
    showBackButton ??= true;
    final List<Widget> actions = [];
    if (action != null) {
      actions.add(action);
    }
    return AppBar(
        automaticallyImplyLeading: showBackButton,
        brightness: brightness ?? Theme.of(context).appBarTheme.brightness,
        elevation: elevation ?? 5,
        backgroundColor: backgroundColor ?? Theme.of(context).appBarTheme.color,
        titleSpacing: 2,
        title: titleWidget != null
            ? titleWidget
            : AutoSizeText(
                title,
                maxLines: 1,
                minFontSize: 21,
                overflow: TextOverflow.clip,
                style: Theme.of(context).appBarTheme.textTheme.title,
              ),
        centerTitle: false,
        actions: actions);
  }
}

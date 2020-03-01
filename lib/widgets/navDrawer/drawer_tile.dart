import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    Key key,
    @required this.text,
    @required this.icon,
  }) : super(key: key);
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final TextStyle itemStyle =
        Theme.of(context).textTheme.body1.copyWith(fontSize: 16.0);

    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10),
          ),
          AutoSizeText(
            text,
            style: itemStyle,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

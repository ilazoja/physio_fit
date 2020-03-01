import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class GetIconAndHeadingRow extends StatelessWidget {
  const GetIconAndHeadingRow(
      {Key key, this.headingIcon, @required this.headingText})
      : super(key: key);

  final IconData headingIcon;
  final String headingText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        headingIcon == null
            ? const Padding(padding: EdgeInsets.only(left: 40.0))
            : Icon(headingIcon),
        const Padding(padding: EdgeInsets.only(left: 5.0)),
        Expanded(
            child: AutoSizeText(headingText,
                style: Theme.of(context).textTheme.display4))
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class GetItemTextRow extends StatelessWidget {
  const GetItemTextRow({Key key, @required this.bodyText}) : super (key: key);

  final String bodyText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(29, 0, 20, 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: AutoSizeText(bodyText,
                style: Theme
                    .of(context)
                    .textTheme
                    .body1),
          )
        ],
      ),
    );  }
}

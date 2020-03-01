import 'package:flutter/material.dart';
import 'package:physio_tracker_app/themeData.dart';


class KiqbackLogo extends StatelessWidget {
  const KiqbackLogo(this.topMargin, this.leftMargin,
      this.rightMargin, this.bottomMargin);

  final double topMargin;
  final double leftMargin;
  final double rightMargin;
  final double bottomMargin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          margin: EdgeInsets.fromLTRB(leftMargin, topMargin, bottomMargin, rightMargin),
          child: RichText(
            text: TextSpan(
              style: loginTheme.logoStyle,
              children: <TextSpan>[
                const TextSpan(text: 'Kiqback'),
                TextSpan(
                    text: '.',
                    style: TextStyle(color: loginTheme.accentColor)),
              ],
            ),
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:physio_tracker_app/themeData.dart';

class SubHeading extends StatelessWidget {
  const SubHeading({
    Key key,
    @required this.heading,
  }) : super(key: key);

  final String heading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(
          top: 17,
          left: 15,
        ),
        child: AutoSizeText(
          heading,
          style: TextStyle(
              fontSize: 21,
              fontFamily: mainFontBold,
              color: greyAccent,
              fontWeight: FontWeight.bold),
          maxLines: 1,
        ));
  }
}

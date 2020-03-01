import 'package:flutter/material.dart';

class GenericHorizontalBox extends StatelessWidget {
  GenericHorizontalBox({
    Key key,
    @required this.children,
  }) : super(key: key);

  List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height / 60,
        ),
        height: 270 + MediaQuery.of(context).size.height / 60,
        child:
        ListView(
          padding: const EdgeInsets.only(left:10, right: 10),
          semanticChildCount: 1,
          scrollDirection: Axis.horizontal,
          children: children,
        )
    );

  }
}
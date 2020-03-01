import 'package:flutter/material.dart';

class SubTile extends StatelessWidget {
  const SubTile({
    Key key,
    @required this.tileHeading, @required this.trailingWidget,
  }) : super(key: key);
  final String tileHeading;
  final Widget trailingWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      //alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            tileHeading,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          Container(
            padding:  const EdgeInsets.only(right: 15),
            child: trailingWidget,),
        ],
      ),
    );
  }
}

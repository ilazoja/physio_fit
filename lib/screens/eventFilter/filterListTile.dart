import 'package:flutter/material.dart';
import 'package:physio_tracker_app/themeData.dart';

class FilterListTile extends StatefulWidget {
  FilterListTile({Key key, @required this.tileText}) : super(key: key);
  final String tileText;
  bool clicked = false;

  FilterListTileState tileState;

  @override
  FilterListTileState createState() => generateState();

  FilterListTileState generateState() {
    tileState = FilterListTileState();
    return tileState;
  }
}

class FilterListTileState extends State<FilterListTile> {
  void resetTile() {
    setState(() {
      widget.clicked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 30),
      title: Text(widget.tileText,
          style: TextStyle(fontSize: 16, fontFamily: mainFont)),
      trailing: Icon(widget.clicked ? Icons.check_box : Icons.check_box_outline_blank,
          color: widget.clicked ? Theme.of(context).accentColor : Colors.grey),
      onTap: () {
        setState(() {
          widget.clicked = !widget.clicked;
        });
      },
    );
  }
}

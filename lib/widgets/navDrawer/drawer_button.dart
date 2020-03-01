import 'package:flutter/material.dart';

class DrawerButton extends StatelessWidget {
  const DrawerButton(
      {Key key,
      @required this.text,
      @required this.icon,
      @required this.onPressed})
      : super(key: key);
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final TextStyle drawerButtonStyle =
    Theme.of(context).textTheme.body1.copyWith(fontSize: 17.0, color: Theme
        .of(context).accentColor);

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      height: 60,
      child: FlatButton(
        padding: const EdgeInsets.only(left: 5),
        splashColor: Theme.of(context).splashColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              icon,
              color: Theme.of(context).accentColor,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
            ),
            Text(
              text,
              style: drawerButtonStyle,
            ),
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}

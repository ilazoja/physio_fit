import 'package:flutter/material.dart';

class StandardButton extends StatelessWidget {
  StandardButton(
      {Key key, @required this.text, this.onPressed, this.buttonColor})
      : super(key: key);
  final String text;
  final Function onPressed;
  Color buttonColor;

  @override
  Widget build(BuildContext context) {
    buttonColor ??= Theme.of(context).accentColor;

    return SizedBox(
      height: 40.0,
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        elevation: 5.0,
        child: Text(text, style: Theme.of(context).textTheme.button),
        onPressed: onPressed,
        disabledElevation: 0.0,
        color: buttonColor,
        disabledColor: buttonColor.withOpacity(0.4),
      ),
    );
  }
}

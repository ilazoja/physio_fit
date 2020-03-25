import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  const NextButton({@required this.callback, @required this.buttonText, @required this.scaleFactor});
  final String buttonText;
  final VoidCallback callback;
  final double scaleFactor;
  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 10, bottom: 40),
        child: SizedBox(
          height: 100.0,
          child: FloatingActionButton.extended(
            label: Row(
              children: <Widget>[Text(buttonText, textScaleFactor: scaleFactor), Icon(Icons.arrow_forward_ios)],
            ),
            backgroundColor: Colors.orange[300],
            onPressed: callback,
          ),
        ));
  }
}

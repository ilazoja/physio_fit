import 'package:flutter/material.dart';

class AddExerciseButton extends StatelessWidget {
  const AddExerciseButton({this.callback, this.buttonText});
  final VoidCallback callback;
  final String buttonText;

  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 0, bottom: 40),
        child: SizedBox(
          height: 43.0,
          child: RaisedButton(
            color: Colors.white,
            textColor: Theme.of(context).accentColor,
            elevation: 5.0,
            child: Text(buttonText),
            onPressed: callback,
          ),
        ));
  }
}

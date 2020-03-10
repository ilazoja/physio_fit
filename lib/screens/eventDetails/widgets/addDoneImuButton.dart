import 'package:flutter/material.dart';

class AddDoneImuButton extends StatelessWidget {
  const AddDoneImuButton({this.callback, this.buttonText});
  final String buttonText;
  final VoidCallback callback;
  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 10, bottom: 40),
        child: SizedBox(
          height: 43.0,
          child: FloatingActionButton.extended(
            icon: Icon(Icons.check),
            label: Text(buttonText),
            onPressed: callback
          ),
        ));
  }
}

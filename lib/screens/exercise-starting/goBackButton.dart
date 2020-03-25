import 'package:flutter/material.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton({@required this.callback});
  final VoidCallback callback;
  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 10, bottom: 40),
        child: SizedBox(
          height: 50.0,
          child: FloatingActionButton.extended(
            label: Row(
              children: <Widget>[Icon(Icons.arrow_back_ios)],
            ),
            backgroundColor: Colors.green[400],
            onPressed: callback,
          ),
        ));
  }
}

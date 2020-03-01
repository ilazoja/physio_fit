import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/widgets/login/loginDialog.dart';

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: RaisedButton(
        padding: const EdgeInsets.all(8.0),
        textColor: Colors.white,
        color: Theme.of(context).accentColor,
        onPressed: () {
          LoginDialog(context);
        },
        child: const Text('Login'),
      )),
    );
  }
}

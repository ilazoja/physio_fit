import 'package:flutter/material.dart';
import 'package:physio_tracker_app/widgets/shared/standardButton.dart';
import 'package:physio_tracker_app/themeData.dart';

typedef VoidCallback = void Function();

class PrimaryLoginButton extends StatelessWidget {
  const PrimaryLoginButton(this.callback, this._buttonString);

  final VoidCallback callback;
  final String _buttonString;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          0.0, MediaQuery.of(context).size.width * 0.04, 0.0, 0.0),
      child: StandardButton(
        text: _buttonString,
        onPressed: callback,
        buttonColor: loginTheme.accentColor,
      ),
    );
  }
}

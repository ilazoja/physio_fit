import 'package:flutter/material.dart';
import 'package:physio_tracker_app/themeData.dart';
import '../../../copyDeck.dart' as copy;
import '../form_mode.dart';

typedef VoidCallback = void Function();

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({this.callback});

  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: loginTheme.secondaryTextStyle,
            children: <TextSpan>[
          TextSpan(
          text: copy.forgotPassword + ' ',
          ),
        TextSpan(
            text: copy.clickHereToReset,
            style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          )
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:physio_tracker_app/themeData.dart';
import '../../../copyDeck.dart' as copy;
import '../form_mode.dart';

typedef VoidCallback = void Function();

class SecondaryLoginButton extends StatelessWidget {
  const SecondaryLoginButton({this.formMode, this.callback});

  final FormMode formMode;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: loginTheme.secondaryTextStyle,
            children: _buildTextChildren(formMode),
          )),
    );
  }

  List<TextSpan> _buildTextChildren(FormMode formMode) {
    if (formMode == FormMode.LOGIN) {
      return <TextSpan>[
        TextSpan(
          text: copy.doNotHaveAnAccountFormText,
        ),
        TextSpan(
            text: copy.signUpFormText,
            style: TextStyle(fontWeight: FontWeight.bold)),
      ];
    } else {
      return <TextSpan>[
        TextSpan(text: copy.haveAnAccountFormText),
        TextSpan(
            text: copy.signInFormText,
            style: TextStyle(fontWeight: FontWeight.bold)),
      ];
    }
  }
}

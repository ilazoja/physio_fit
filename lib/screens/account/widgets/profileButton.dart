import 'package:flutter/material.dart';
import 'package:physio_tracker_app/themeData.dart';

typedef VoidCallback = void Function();

class ProfileButton extends StatelessWidget {
  ProfileButton({this.callback, this.buttonText, this.color});

  final VoidCallback callback;
  final String buttonText;
  Color color;

  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
        child: SizedBox(
          child: OutlineButton(
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
            color: Theme.of(context).primaryColorLight,
            textColor: Theme.of(context).primaryColor,
            child: Text(
                buttonText,
                style: accountTheme.profileButtonTextStyle.copyWith(color:
                color)
            ),
            onPressed: callback,
          ),
        ),
    );
  }
}

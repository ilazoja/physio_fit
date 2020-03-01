import 'package:flutter/material.dart';

typedef VoidCallback = void Function();

class SocialMediaSignInButton extends StatelessWidget {

  const SocialMediaSignInButton(this._callback, this._socialMediaIcon,
      this._buttonText);

  final VoidCallback _callback;
  final IconData _socialMediaIcon;
  final String _buttonText;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: _callback,
      padding: const EdgeInsets.only(top: 3.0, bottom: 3.0, left: 3.0),
      color: Theme.of(context).buttonColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(_socialMediaIcon),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                _buttonText,
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              )
          ),
        ],
      ),
    );
  }
}
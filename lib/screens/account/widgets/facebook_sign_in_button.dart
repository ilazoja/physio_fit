import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import '../../../copyDeck.dart' as copy;
import 'social_media_sign_in_button.dart';

class FacebookSignInButton extends StatelessWidget {

  const FacebookSignInButton(this._callback);
  final VoidCallback _callback;

  @override
  Widget build(BuildContext context) {
    return SocialMediaSignInButton(
        _callback,
        FontAwesomeIcons.facebookF,
        copy.signInWithFacebookText
    );
  }
}
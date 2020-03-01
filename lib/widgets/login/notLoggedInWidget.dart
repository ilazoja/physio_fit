import 'package:flutter/material.dart';
import 'package:physio_tracker_app/widgets/login/loginButton.dart';
import 'package:physio_tracker_app/widgets/shared/centeredTextPrompt.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotLoggedInWidget extends StatelessWidget {
  const NotLoggedInWidget({Key key, @required this.textCopy}) : super(key: key);

  final String textCopy;

  @override
  Widget build(BuildContext context) {
    const String backgroundImage = 'assets/illustrations/notLoggedInScreen.svg';
    return Container(
//      padding: const EdgeInsets.all(10),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          Expanded(
            child: SvgPicture.asset(backgroundImage, fit: BoxFit.fitWidth),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: CenteredTextPrompt(textCopy),
          ),
          LoginButton(),
        ]));
  }
}

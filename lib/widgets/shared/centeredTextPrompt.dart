import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../themeData.dart';

class CenteredTextPrompt extends StatelessWidget {
  const CenteredTextPrompt(this._message);

  final String _message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AutoSizeText(
        _message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18.0,
          color: themeData.accentColor,
          height: 1.2,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

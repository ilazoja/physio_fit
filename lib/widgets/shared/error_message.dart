import 'package:flutter/material.dart';
import '../../themeData.dart';

class ErrorMessage extends StatelessWidget {

  const ErrorMessage(this._errorMessage);
  final String _errorMessage;

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null && _errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          _errorMessage,
          style: TextStyle(
              fontSize: 13.0,
              color: themeData.errorColor,
              height: 1.0,
              fontWeight: FontWeight.w300),
        ),
      );
    }
    else {
      return Container(
        height: 0.0,
      );
    }
  }
}
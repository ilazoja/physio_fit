import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:physio_tracker_app/themeData.dart';
import 'package:physio_tracker_app/helpers/dateTimeHelper.dart';
import '../../../copyDeck.dart' as copy;

typedef VoidCallback = void Function(String val, bool isValidated);

class LoginInput extends StatelessWidget {
  final VoidCallback callback;

  final LoginInputType loginType;
  const LoginInput({this.callback, this.loginType});

  bool allowObscureText() {
    return loginType == LoginInputType.PASSWORD;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: TextFormField(
          keyboardAppearance: Theme.of(context).brightness,
          maxLines: 1,
          keyboardType: getKeyboardType(),
          obscureText: allowObscureText(),
          autofocus: false,
          decoration: InputDecoration(
            fillColor: Colors.white12,
            filled: true,
            hintText: getHintText(),
            hintStyle: loginTheme.hintStyle,
            errorStyle: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold
            ),
            icon: Icon(getIcon(), color: Colors.white),
            border: InputBorder.none,
          ),
          inputFormatters: getInputFormatter(),
          validator: (String value) {
            return inputValidation(value);
          },
          onSaved: (String value) => callback(value, true),
          cursorColor: Theme.of(context).cursorColor,
          style: Theme.of(context)
              .textTheme
              .body2
              .copyWith(color: loginTheme.primaryColor),
        ),
      ),
    );
  }

  String fieldEmptyError() {
    switch (loginType) {
      case LoginInputType.EMAIL:
        return copy.emailEmptyError;
      case LoginInputType.PASSWORD:
        return copy.passwordEmptyError;
      case LoginInputType.FNAME:
        return copy.fnameEmptyError;
      case LoginInputType.LNAME:
        return copy.lnameEmptyError;
      case LoginInputType.PHONE:
        return copy.phoneEmptyError;
      case LoginInputType.DOB:
        return copy.dobEmptyError;
      case LoginInputType.TYPE:
        return copy.dobEmptyError;
    }
  }

  String getHintText() {
    switch (loginType) {
      case LoginInputType.EMAIL:
        return copy.emailInputHint;
      case LoginInputType.PASSWORD:
        return copy.passwordInputHint;
      case LoginInputType.FNAME:
        return copy.fnameInputHint;
      case LoginInputType.LNAME:
        return copy.lnameInputHint;
      case LoginInputType.PHONE:
        return copy.phoneInputHint;
      case LoginInputType.DOB:
        return copy.dobInputHint;
      case LoginInputType.TYPE:
        return copy.typeInputHint;
    }
  }

  IconData getIcon() {
    switch (loginType) {
      case LoginInputType.EMAIL:
        return Icons.mail;
      case LoginInputType.PASSWORD:
        return Icons.lock;
      case LoginInputType.FNAME:
        return Icons.person;
      case LoginInputType.LNAME:
        return Icons.person;
      case LoginInputType.PHONE:
        return Icons.phone;
      case LoginInputType.DOB:
        return Icons.cake;
      case LoginInputType.TYPE:
        return Icons.person;
    }
  }

  List<TextInputFormatter> getInputFormatter() {
    if (loginType == LoginInputType.PHONE) {
      return <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10)
      ];
    }

    if (loginType == LoginInputType.DOB) {
      return <TextInputFormatter>[
        BlacklistingTextInputFormatter(RegExp(':-.'))
      ];
    }
  }

  TextInputType getKeyboardType() {
    switch (loginType) {
      case LoginInputType.EMAIL:
        return TextInputType.emailAddress;
      case LoginInputType.PASSWORD:
        return TextInputType.text;
      case LoginInputType.FNAME:
        return TextInputType.text;
      case LoginInputType.LNAME:
        return TextInputType.text;
      case LoginInputType.PHONE:
        return TextInputType.phone;
      case LoginInputType.DOB:
        return TextInputType.datetime;
      case LoginInputType.TYPE:
        return TextInputType.text;
    }
  }

  String inputValidation(String value) {
    if (value.replaceAll(' ', '').trim().isEmpty) {
      callback(value, false);
      return fieldEmptyError();
    } else if (loginType == LoginInputType.PHONE && value.length < 10) {
      callback(value, false);
      return copy.phoneLengthError;
    } else if (loginType == LoginInputType.DOB && !isValidDOB(value)) {
      callback(null, false);
      return copy.dobInvalidError;
    }
  }

  bool isValidDOB(String value) {
    try {
      final DateTime dateTime = DateTimeHelper.stringToDateTime(value);
      if (dateTime.isAfter(DateTime.now())) {
        return false;
      }
      return value == DateTimeHelper.dateTimeToString(dateTime);
    } catch (e) {
      print(e);
      return false;
    }
  }
}

enum LoginInputType { EMAIL, PASSWORD, FNAME, LNAME, DOB, PHONE, TYPE }

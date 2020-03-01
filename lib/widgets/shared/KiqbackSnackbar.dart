import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KiqbackSnackbar {
  KiqbackSnackbar();

  SnackBar build(String snackbarText) {
    return SnackBar(
      content: Text(snackbarText),
      duration: Duration(seconds: 3),
    );
  }
}
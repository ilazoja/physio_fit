import 'package:flutter/material.dart';
import 'package:physio_tracker_app/widgets/shared/circular_progress.dart';

typedef MyCallback = Function();
class CircularProgressDialog {
  CircularProgressDialog (BuildContext context, MyCallback callback) {
    showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: const CircularProgress(isLoading: true),
        );
      },
    );
    callback();
  }

}
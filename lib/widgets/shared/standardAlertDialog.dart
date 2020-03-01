import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;

class StandardAlertDialog {
  StandardAlertDialog(BuildContext context, String title, String content) {
    showDialog<Dialog>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: content.isNotEmpty ? Text(content) : null,
            actions: <Widget>[
              FlatButton(
                child: Text(copy.alertDialogConfirmationText),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}

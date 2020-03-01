import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;

class StandardConfirmationDialog {
  StandardConfirmationDialog(BuildContext context, String title, Function
  confirmed) {
    showDialog<Dialog>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            actions: <Widget>[
              FlatButton(
                child: Text(copy.confirmationDialogCancel),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(copy.confirmationDialogConfirm),
                onPressed: confirmed,
              )
            ],
          );
        });
  }
}

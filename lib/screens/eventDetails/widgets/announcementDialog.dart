import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/event.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';

class AnnouncementDialog extends StatefulWidget {
  const AnnouncementDialog({Key key, @required this.event, @required this
      .scaffoldState}) : super(key:
  key);

  final Event event;
  final ScaffoldState scaffoldState;
  @override
  AnnouncementDialogState createState() => AnnouncementDialogState();
}

class AnnouncementDialogState extends State<AnnouncementDialog> {
  final TextEditingController _text = TextEditingController();
  bool _validateDialog = false;

  void broadcastMessage(String message) {
    print(message);
    Map<String, dynamic> map = <String, dynamic>{
      'message': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString()
    };
    CloudDatabase.addAnouncementToEvent(
        widget.event, map, onAnnouncementCallback);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Announcement for Guest List'),
      content: TextField(
        cursorColor: Theme.of(context).accentColor,
        controller: _text,
        maxLines: 5,
        decoration: InputDecoration(
          hintText: 'Enter your announcement here',
          errorText: !_validateDialog ? 'Value Can\'t Be Empty' : null,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          textTheme: Theme.of(context).buttonTheme.textTheme,
          child: Text(
            'CANCEL',
            style: TextStyle(color: Colors.redAccent),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          textTheme: Theme.of(context).buttonTheme.textTheme,
          child: Text('SEND',
              style: TextStyle(
                color: _validateDialog
                    ? Theme.of(context).accentColor
                    : Theme.of(context).disabledColor,
              )),
          onPressed: () {
            if (_validateDialog) {
              broadcastMessage(_text.text.toString());
            }
          },
        )
      ],
    );
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _text.addListener(_updateDialogTextField);
    super.initState();
  }

  void onAnnouncementCallback(bool success) {
    Navigator.of(context).pop();
    if (success) {
      showInSnackBar('Notified Guests!');
    } else {
      showInSnackBar('Failed to deliver your message!');
    }
  }

  void showInSnackBar(String value) {
    widget.scaffoldState.showSnackBar(SnackBar(
      content: Text(value),
      duration: Duration(seconds: 2),
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'DISMISS',
        onPressed: widget.scaffoldState.hideCurrentSnackBar,
      ),
    ));
  }

  void _updateDialogTextField() {
    setState(() {
      _validateDialog = _text.text.isNotEmpty;
    });
  }
}
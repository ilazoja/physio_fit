import 'package:flutter/material.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;

class CancelDialog extends StatefulWidget {
  CancelDialog({Key key, this.confirmationFunc}) : super(key: key);

  final Function confirmationFunc;
  String cancellationDropdownValue;

  @override
  CancelDialogState createState() => CancelDialogState();
}

class CancelDialogState extends State<CancelDialog> {
  final TextEditingController _text = TextEditingController();
  bool _validateDialog = false;

  @override
  Widget build(BuildContext context) {
    bool formValid =(_validateDialog &&
        widget.cancellationDropdownValue ==
            copy.dropdownOtherText) ||
        (widget.cancellationDropdownValue != null &&
            widget.cancellationDropdownValue !=
                copy.dropdownOtherText);
    return AlertDialog(
      title: Text(copy.confirmationDialogTitle),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DropdownButton<String>(
                hint: Text(copy.cancellationReason),
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down),
                iconSize: 24,
                elevation: 16,
                style:
                    Theme.of(context).textTheme.body1.copyWith(fontSize: 16.0),
                underline: const Padding(padding: EdgeInsets.all(5)),
                onChanged: (String newValue) {
                  setState(() {
                    widget.cancellationDropdownValue = newValue;
                  });
                },
                value: widget.cancellationDropdownValue,
                items: copy.hostCancellationPolicyValues
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList()),
            Divider(),
            widget.cancellationDropdownValue ==
                    copy.dropdownOtherText
                ? TextField(
                    cursorColor: Theme.of(context).accentColor,
                    controller: _text,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: copy.cancellationReason,
                      errorText:
                          !_validateDialog ? 'Value Can\'t Be Empty' : null,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          textTheme: Theme.of(context).buttonTheme.textTheme,
          child: Text(
            copy.confirmationDialogCancel,
            style: TextStyle(color: Colors.redAccent),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          textTheme: Theme.of(context).buttonTheme.textTheme,
          child: Text(copy.cancellationConfirmation,
              style: TextStyle(
                color: formValid
                    ? Theme.of(context).accentColor
                    : Theme.of(context).disabledColor,
              )),
          onPressed: () {
            if (formValid) {
              widget.confirmationFunc();
              Navigator.of(context).pop();
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
    widget.cancellationDropdownValue = null;
    _text.addListener(_updateDialogTextField);
    super.initState();
  }

  void _updateDialogTextField() {
    setState(() {
      _validateDialog = _text.text.isNotEmpty;
    });
  }
}

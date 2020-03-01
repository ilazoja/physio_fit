import 'package:flutter/material.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;
import 'package:physio_tracker_app/widgets/shared/standardButton.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

class RepeatDialog extends StatefulWidget {
  const RepeatDialog({Key key, @required this.firstDate, this.callback})
      : super(key: key);

  final DateTime firstDate;
  final Function callback;

  @override
  _RepeatDialogState createState() => _RepeatDialogState();
}

String repeatValue;
DateTime reoccuranceEnd;

class _RepeatDialogState extends State<RepeatDialog> {
  final DateFormat dateFormat = DateFormat.yMMMMd('en_US').add_jm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AutoSizeText('Repeat Frequency', style: Theme.of(context).textTheme
              .display4),
          const Padding(padding: EdgeInsets.all(25)),

          DropdownButton<String>(
              hint: Text(copy.repeat + '*'),
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down),
              iconSize: 24,
              elevation: 16,
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16.0),
              underline: const Padding(padding: EdgeInsets.all(5)),
              onChanged: (String newValue) {
                setState(() {
                  repeatValue = newValue;
                });
              },
              value: repeatValue,
              items: copy.repeatOptions
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList()),
          _getDivider(),
          getDateTimeEnd(),
          const Padding(padding: EdgeInsets.all(25)),
          StandardButton(text: 'Save', onPressed: saveAction())
        ],
      ),
    ));
  }

  Function saveAction() {
    if (repeatValue == null ||
        reoccuranceEnd == null ||
        reoccuranceEnd.isBefore(widget.firstDate)) {
      return null;
    } else {
      return () {
        List<DateTime> reoccuringDates = <DateTime>[];
        DateTime nextDate = widget.firstDate;
        while (nextDate.isBefore(reoccuranceEnd)) {
          //daily
          if (repeatValue == copy.repeatOptions[0]) {
            nextDate = nextDate.add(const Duration(days: 1));
          } else if (repeatValue == copy.repeatOptions[1]) {
            nextDate = nextDate.add(const Duration(days: 7));
          } else {
            nextDate =
                DateTime(nextDate.year, nextDate.month + 1, nextDate.day);
          }
          if (nextDate.isBefore(reoccuranceEnd)) {
            reoccuringDates.add(nextDate);
          }
        }

        widget.callback(reoccuringDates);
        Navigator.pop(context);
      };
    }
  }

  DateTimeField getDateTimeEnd() {
    return DateTimeField(
        initialValue: reoccuranceEnd,
        format: dateFormat,
        style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16.0),
        decoration: InputDecoration(
          labelText: copy.endRecurrence + '*',
          fillColor: Theme.of(context).cursorColor,
          border: InputBorder.none,
        ),
        onChanged: (DateTime date) {
          setState(() {
            reoccuranceEnd = date;
          });
        },
        onShowPicker: (BuildContext context, DateTime currentValue) async {
          reoccuranceEnd = await showDatePicker(
              context: context,
              //5 mins ahead start
              firstDate: widget.firstDate.add(const Duration(days: 1)),
              initialDate:
                  currentValue ?? widget.firstDate.add(const Duration(days:
                  20)),
              lastDate: DateTime(2100));
          reoccuranceEnd = DateTimeField.combine(reoccuranceEnd, TimeOfDay
              .fromDateTime(widget.firstDate));
          return reoccuranceEnd;
        });
  }
  Widget _getDivider() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: const Divider(
          color: Colors.black26,
          height: 3,
        ));
  }
}


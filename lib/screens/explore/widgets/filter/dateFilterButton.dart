import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physio_tracker_app/screens/eventFilter/filter.dart';
import 'package:date_range_picker/date_range_picker.dart' as date_range_picker;
import 'package:physio_tracker_app/copyDeck.dart' as copy;

class DateFilterButton extends StatefulWidget {
  DateFilterButton({Key key, @required this.parentContainerHeight})
      : super(key: key);
  static _DateFilterButtonState dateFilterButtonState;


  final double parentContainerHeight;
  static String buttonText = copy.dateFilterButtonText;
  static DateTime startDate;
  static DateTime endDate;
  static bool filterSet =
      DateFilterButton.startDate != null && DateFilterButton.endDate != null;
  Filter filter = Filter();

  @override
  _DateFilterButtonState createState() => generateState();

  _DateFilterButtonState generateState() {
    dateFilterButtonState = _DateFilterButtonState();
    return dateFilterButtonState;
  }
}

class _DateFilterButtonState extends State<DateFilterButton>
    with SingleTickerProviderStateMixin {
  String _getDateRange(DateTime start, DateTime end) {
    final DateFormat formatter = DateFormat('MMM');
    return formatter.format(start) +
        ' ' +
        start.day.toString() +
        ' - ' +
        formatter.format(end) +
        ' ' +
        end.day.toString();
  }

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = Colors.grey[100];
    final Color secondaryColor = Theme.of(context).accentColor;

    return AnimatedSize(
        duration: Duration(milliseconds: 250),
        vsync: this,
        child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: SizedBox(
                height: widget.parentContainerHeight * 0.7,
                child: RaisedButton(
                  splashColor:
                      Colors.transparent,
                  elevation: 0.3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    DateFilterButton.buttonText,
                    style: Theme.of(context).textTheme.body1.copyWith(
                          color: DateFilterButton.filterSet
                              ? buttonColor
                              : secondaryColor,
                        ),
                  ),
                  color: DateFilterButton.filterSet
                      ? secondaryColor
                      : buttonColor,
                  onPressed: () async {
                    final List<DateTime> picked =
                        await date_range_picker.showDatePicker(
                            selectableDayPredicate: (DateTime val) =>
                                val.isAfter(
                                    DateTime.now().subtract(Duration(days: 1))),
                            context: context,
                            initialFirstDate: DateFilterButton.startDate != null
                                ? DateFilterButton.startDate
                                : DateTime.now(),
                            initialLastDate: DateFilterButton.endDate != null
                                ? DateFilterButton.endDate
                                : DateTime.now().add(Duration(days: 3)),
                            firstDate: DateTime(DateTime.now().year),
                            lastDate: DateTime(DateTime.now().year)
                                .add(Duration(days: 730)));
                    setState(() {
                      if (picked != null && picked.length == 2) {
                        DateFilterButton.startDate = picked[0];
                        DateFilterButton.endDate = picked[1];
                        DateFilterButton.buttonText = _getDateRange(
                            DateFilterButton.startDate,
                            DateFilterButton.endDate);
                      } else {
                        DateFilterButton.buttonText = copy.dateFilterButtonText;
                        DateFilterButton.startDate = null;
                        DateFilterButton.endDate = null;
                      }

                      DateFilterButton.filterSet =
                          DateFilterButton.startDate != null &&
                              DateFilterButton.endDate != null;

                      Filter.updateEffectedWidgets();
                    });
                  },
                ))));
  }
}

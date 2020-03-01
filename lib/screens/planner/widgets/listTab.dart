import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/event.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/widgets/events/eventCard.dart';
import 'package:intl/intl.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;
import 'package:physio_tracker_app/widgets/shared/subHeading.dart';

class ListTab extends StatelessWidget {
  const ListTab(this._dateEventMap);

  final Map<DateTime, List<Exercise>> _dateEventMap;

  @override
  Widget build(BuildContext context) {
    return ListView(children: _getListOfDates(context));
  }

  List<Widget> _getListOfDates(BuildContext context) {
    final List<Widget> widgets = <Widget>[];
    final List<DateTime> dates = _dateEventMap.keys.toList();
    //sort dates

    // TODO(all): to sort by time as well need to store time in map
    dates.sort((a, b) => a.compareTo(b));

    for (DateTime date in dates) {
      if (date.isAfter(DateTime.now().subtract(Duration(hours: 24)))) {
        widgets.add(_dateSubHeader(context, date));
        for (Exercise _event in _dateEventMap[date]) {
          widgets
              .add(EventCard(exercise: _event, isPlanner: true, showTime: true));
        }
      }
    }

    return addTextWidget(widgets, context);
  }

  List<Widget> addTextWidget(List<Widget> list, BuildContext context) {
    if (list.isEmpty) {
      // Return 'No Events Found'
      final List<Widget> emptyList = <Widget>[
        Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(copy.plannerListNoEvents,
              style: Theme.of(context).textTheme.display4),
        ))
      ];
      return emptyList;
    } else {
      return list;
    }
  }

  Widget _dateSubHeader(BuildContext context, DateTime date) {
    final String dateS = DateFormat.MMMMEEEEd().format(date);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SubHeading(heading: dateS));
  }
}

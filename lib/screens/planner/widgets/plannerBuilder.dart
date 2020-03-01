import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart' as calendar;
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;
import 'package:physio_tracker_app/widgets/events/eventCard.dart';
import 'package:physio_tracker_app/screens/planner/widgets/calendarTab.dart';
import 'package:physio_tracker_app/helpers/searchHelpers.dart';
import 'package:physio_tracker_app/helpers/widgetHelpers.dart';
import '../../../models/event.dart';
import 'listTab.dart';

class PlannerBuilder extends StatefulWidget {
  const PlannerBuilder(this._textController);

  final TextEditingController _textController;

  @override
  _PlannerBuilderState createState() => _PlannerBuilderState();
}

class _PlannerBuilderState extends State<PlannerBuilder> {
  int _selectedIndexValue;
  final EventList<calendar.Event> _eventsMarkedMap =
      EventList<calendar.Event>(events: {});
  final Map<DateTime, List<Exercise>> _dateEventMap = <DateTime, List<Exercise>>{};

  @override
  void initState() {
    _selectedIndexValue = 0;
    widget._textController.addListener(valueSet);
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  String _searchValue = '';
  bool search = false;

  void valueSet() {
    setState(() {
      _searchValue = widget._textController.text;
      if (_searchValue.isNotEmpty) {
        search = true;
      } else {
        search = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    markDatesMap(context);
    final User _currUserModel = Provider.of<User>(context);
    if (_currUserModel != null) {
      return Container(
        child: search
            ? ListView(
                children: _getSearchedWidgets(context, _currUserModel.id),
              )
            : Column(
                children: <Widget>[
                  SizedBox(
                      width: double.infinity,
                      child: CupertinoSegmentedControl<int>(
                          padding: const EdgeInsets.symmetric(horizontal: 5,
                              vertical: 7),
                        selectedColor: Theme.of(context).accentColor,
                        pressedColor: Theme.of(context).splashColor,
                        borderColor: Theme.of(context).accentColor,
                        children: WidgetHelpers.getTabWidgets(copy
                            .plannerTabBar[0], copy.plannerTabBar[1], context),
                        groupValue: _selectedIndexValue,
                        onValueChanged: (int value) {
                          setState(() => _selectedIndexValue = value);
                        },
                      )),
                  const Padding(
                    padding: EdgeInsets.all(2),
                  ),
                  _selectedIndexValue == 0
                      ? Expanded(
                          child: CalendarTab(
                              eventsMarkedMap: _eventsMarkedMap,
                              dateEventMap: _dateEventMap),
                        )
                      : Expanded(child: ListTab(_dateEventMap)),
                ],
              ),
      );
    }
    return Container();
  }

  void markDatesMap(BuildContext context) {
    _eventsMarkedMap.clear();
    _dateEventMap.clear();
    final List<Exercise> _allEvents = Provider.of<List<Exercise>>(context);
    if (_allEvents != null) {
      final User _currUserModel = Provider.of<User>(context);
      if (_currUserModel != null) {
        for (Exercise _event in _allEvents) {
          if (_event.id == _currUserModel.id) {
            final DateTime date =
                DateTime(_event.date.year, _event.date.month, _event.date.day);
            _eventsMarkedMap.add(date, calendar.Event(date: date));
            addToMap(date, _event);
          }
        }
      }
    }
  }

  void addToMap(DateTime date, Exercise _event) {
    if (_dateEventMap.containsKey(date)) {
      final List<Exercise> currDateList = _dateEventMap[date];
      currDateList.add(_event);
      _dateEventMap[date] = currDateList;
    } else {
      _dateEventMap[date] = <Exercise>[_event];
    }
  }

  List<Widget> _getSearchedWidgets(BuildContext context, String _userId) {
    final List<Exercise> _allEvents = Provider.of<List<Exercise>>(context);
    final List<Widget> list = <Widget>[];
    final User _currUserModel = Provider.of<User>(context);
    if (_allEvents != null) {
      if (_currUserModel != null) {
        for (Exercise _event in _allEvents) {
            list.add(EventCard(exercise: _event, isPlanner: true));
        }
      }
    }

    return SearchHelpers.addSearchResults(list, context);
  }

}

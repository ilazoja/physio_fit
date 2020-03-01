import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart' as calendar;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/themeData.dart';
import 'package:physio_tracker_app/widgets/events/eventCard.dart';
import 'package:intl/intl.dart';
import '../../../models/event.dart';

class CalendarTab extends StatefulWidget {
  const CalendarTab(
      {@required this.eventsMarkedMap, @required this.dateEventMap});

  final EventList<calendar.Event> eventsMarkedMap;
  final Map<DateTime, List<Exercise>> dateEventMap;

  @override
  _CalendarTabState createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  DateTime _currentDate = DateTime.now();
  List<Widget> list = <Widget>[];

  @override
  void initState() {
    super.initState();
    final DateTime dateTimeNow = DateTime.now();
    _currentDate =
        DateTime(dateTimeNow.year, dateTimeNow.month, dateTimeNow.day);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, children: _getUnsearchedWidgets(context));
  }

  Widget getCalendar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2.5),
      child: CalendarCarousel(
        onDayPressed: (DateTime date, List<calendar.Event> events) {
          setState(() {
            _currentDate = date;
          });
        },
        iconColor: Colors.black,
        headerMargin: const EdgeInsets.all(0),
        pageScrollPhysics: null,
        headerTextStyle:
            Theme.of(context).textTheme.display1.copyWith(fontSize: 22),
        weekdayTextStyle: calendarCarouselTheme.weekdayTextStyle,
        weekendTextStyle: calendarCarouselTheme.weekendTextStyle,
        thisMonthDayBorderColor: calendarCarouselTheme.thisMonthDayBorderColor,
        todayButtonColor: calendarCarouselTheme.todayButtonColor,
        todayTextStyle: calendarCarouselTheme.todayTextStyle,
        todayBorderColor: calendarCarouselTheme.todayBorderColor,
        weekFormat: calendarCarouselTheme.weekFormat,
        markedDatesMap: widget.eventsMarkedMap,
        height: MediaQuery.of(context).size.height / 2.2,
        markedDateIconBorderColor:
            calendarCarouselTheme.markedDateIconBorderColor,
        markedDateIconBuilder: calendarCarouselTheme.markedDateIconBuilder,
        markedDateIconMaxShown: calendarCarouselTheme.markedDateIconMaxShown,
        selectedDayButtonColor: calendarCarouselTheme.selectedDayButtonColor,
        selectedDayBorderColor: calendarCarouselTheme.selectedDayBorderColor,
        selectedDayTextStyle: calendarCarouselTheme.selectedTextStyle,
        selectedDateTime: _currentDate,
        daysHaveCircularBorder: calendarCarouselTheme.daysHaveCircularBorder,
      ),
    );
  }

  List<Widget> _getUnsearchedWidgets(BuildContext context) {
    list = <Widget>[];
    list.add(getCalendar());
    list.add(getDivider());

    if (widget.dateEventMap[_currentDate] != null) {
      for (Exercise dateEvent in widget.dateEventMap[_currentDate]) {
        list.add(EventCard(exercise: dateEvent, isPlanner: true));
      }
    }
    return list;
  }

  Widget getDivider() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: const Divider());
  }

  String formatCompareDate(DateTime date) {
    return DateFormat('YYYYMMDD').format(date);
  }
}

import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/screens/explore/widgets/horizontalScroll/'
    'genericHorizontalBox.dart';
import 'package:physio_tracker_app/screens/explore/widgets/eventBox.dart';
import 'package:physio_tracker_app/widgets/events/getIconAndHeadingRow.dart';

class MoreDateEventsScrolling extends StatelessWidget {
  const MoreDateEventsScrolling({Key key, this.exercises, this.currentEventDate})
      : super(key: key);

  final List<Exercise> exercises;
  final DateTime currentEventDate;

  @override
  Widget build(BuildContext context) {
    const double eventBoxAspectRatio = 0.6;
    final List<Widget> dateEvents = <Widget>[];

    for (Exercise exercise in exercises) {
      dateEvents.add(EventBox(
        exercise: exercise,
        setSmall: true,
        detailsPage: true,
      ));
    }
    return dateEvents.isNotEmpty
        ? Column(
            children: <Widget>[
              _getDivider(),
              const Padding(
                padding: EdgeInsets.only(left: 17.0, bottom: 5),
                child: GetIconAndHeadingRow(
                    headingText: 'Event On Other Dates',
                    headingIcon: Icons.date_range),
              ),
              GenericHorizontalBox(
                children: dateEvents
                    .map((Widget widget) => AspectRatio(
                        aspectRatio: eventBoxAspectRatio, child: widget))
                    .toList(),
              ),
            ],
          )
        : Container();
  }

  Widget _getDivider() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 15),
        child: const Divider());
  }
}

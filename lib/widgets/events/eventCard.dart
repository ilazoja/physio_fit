import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/event.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:flutter/cupertino.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'package:physio_tracker_app/screens/eventDetails/index.dart';
import './plannerListItem.dart';

class EventCard extends StatelessWidget {
  const EventCard({this.exercise, this.isPlanner, this.showTime});

  final Exercise exercise;
  final bool isPlanner;
  final bool showTime;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: GestureDetector(
          onTap: () {
            Navigator.of(context).push<dynamic>(DefaultPageRoute<dynamic>(
                pageRoute: EventDetailsProviderWrapper(exercise: exercise)));
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: PlannerListItem(exercise, showTime),
                  )
                ],
              ),
          ),
          ),
        ));
  }

  Color getBottomDetailColor(BuildContext context, String type) {
    switch (type) {
      case 'Favorited':
        return Colors.red[400];
      case 'Attending':
        return Theme.of(context).accentColor;
      case 'Hosting':
        return Theme.of(context).accentColor;
    }
    return Theme.of(context).accentColor;
  }
}

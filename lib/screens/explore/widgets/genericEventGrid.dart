import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/event.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'eventBox.dart';

class GenericEventGrid extends StatefulWidget {
  const GenericEventGrid({Key key, @required this.events}) : super(key: key);
  final List<Exercise> events;

  @override
  _GenericEventGridState createState() => _GenericEventGridState();
}

class _GenericEventGridState extends State<GenericEventGrid> {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
        padding: EdgeInsets.only(
          left: 10,
          top: MediaQuery.of(context).size.height / 60,
          bottom: 0,
          right: 10,
        ),
        sliver: SliverGrid.count(
            childAspectRatio: MediaQuery.of(context).size.width / 1000 * 1.9,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
            crossAxisCount: 2,
            children: _createEventBoxes(context, widget.events)));
  }

  List<Widget> _createEventBoxes(BuildContext context, List<Exercise> exercises) {
    final List<Widget> eventBoxes = <Widget>[];

    for (Exercise exercise in exercises) {
      eventBoxes.add(EventBox(
        exercise: exercise,
        setSmall: false,
      ));
    }

    return eventBoxes;
  }
}

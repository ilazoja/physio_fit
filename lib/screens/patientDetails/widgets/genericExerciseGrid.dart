import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/event.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'exerciseBox.dart';

class GenericExerciseGrid extends StatefulWidget {
  const GenericExerciseGrid({Key key, @required this.exercises}) : super(key: key);
  final List<Exercise> exercises;

  @override
  _GenericExerciseGridState createState() => _GenericExerciseGridState();
}

class _GenericExerciseGridState extends State<GenericExerciseGrid> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
          _createEventBoxes(context, widget.exercises)
      ),
    );
  }

  List<Widget> _createEventBoxes(BuildContext context, List<Exercise> exercises) {
    final List<Widget> eventBoxes = <Widget>[];

    for (Exercise exercise in exercises) {
      if (!exercise.name.isEmpty) {
        eventBoxes.add(ExerciseBox(
          exercise: exercise,
          setSmall: false,
        ));
      }
    }

    return eventBoxes;
  }
}

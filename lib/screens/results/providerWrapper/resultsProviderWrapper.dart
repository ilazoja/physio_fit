import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:physio_tracker_app/models/event.dart';
import 'package:physio_tracker_app/models/completed_exercise.dart';
import 'package:physio_tracker_app/screens/eventDetails/eventDetails.dart';
import 'package:physio_tracker_app/screens/eventDetails/exerciseStartScreen.dart';
import 'package:physio_tracker_app/screens/results/result.dart';

class ResultsProviderWrapper extends StatelessWidget {

  const ResultsProviderWrapper({Key key, this.exercise}) : super(key: key);

  final CompletedExercise exercise;

  @override
  Widget build(BuildContext context) {
    print("PROVIDER");
    return StreamProvider<CompletedExercise>.value(
      value: CloudDatabase.streamResult(exercise.id),
      child: Result(exercise: exercise),
      // child: EventDetails(),
    );
  }
}
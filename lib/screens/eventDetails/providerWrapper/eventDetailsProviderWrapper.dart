import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:physio_tracker_app/models/event.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/screens/eventDetails/eventDetails.dart';
import 'package:physio_tracker_app/screens/eventDetails/exerciseStartScreen.dart';

class EventDetailsProviderWrapper extends StatelessWidget {

  const EventDetailsProviderWrapper({Key key, this.exercise}) : super(key: key);

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    print("PROVIDER");
    return StreamProvider<Exercise>.value(
      value: CloudDatabase.streamEvent(exercise.id),
      child: ExerciseStartScreen(),
      // child: EventDetails(),
    );
  }
}
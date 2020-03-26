import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physio_tracker_app/screens/eventDetails/providerWrapper/guestListProviderWrapper.dart';
import 'package:physio_tracker_app/screens/eventDetails/widgets/donning5Sensor1.dart';
import 'package:physio_tracker_app/screens/exercise-starting/explainIMU.dart';
import 'package:physio_tracker_app/screens/inbox/providerWrapper/chatScreenProviderWrapper.dart';
import 'package:physio_tracker_app/screens/eventDetails/widgets/announcementDialog.dart';
import 'package:physio_tracker_app/widgets/shared/circular_progress.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:physio_tracker_app/widgets/events/getIconAndHeadingRow.dart';
import 'package:physio_tracker_app/widgets/events/getItemTextRow.dart';
import 'package:physio_tracker_app/screens/patientDetails/widgets/addExerciseButton.dart';

import 'package:physio_tracker_app/copyDeck.dart' as copy;
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/models/completed_exercise.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';

class ResultDetail extends StatelessWidget {
  ResultDetail(
      {Key key, @required this.exercise, @required this.index })
      : super(key: key);

  final CompletedExercise exercise;
  final int index;
  BuildContext context;
  ScaffoldState scaffoldState;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    final FirebaseUser firebaseUser = Provider.of<FirebaseUser>(context);

    if (exercise != null) {

      final List<Widget> listViewItems = <Widget>[];

      if (exercise != null) {
        listViewItems.add(Wrap(runSpacing: 4.5, children: <Widget>[
          _getIconAndText(Icons.location_city, 'Name: ' + exercise.name, context),
          _getIconAndText(
              Icons.accessibility,
              'Sets: ' + exercise.sets.toString(),
              context),
          _getIconAndText(
              Icons.accessibility,
              'Time: ' + exercise.workout_time.toString(),
              context),
          _getIconAndText(Icons.accessibility,
              'Correct Reps: ' + exercise.correct_reps_array[index].toString(), context),
          _getIconAndText(
              Icons.category,
              'Attempted Reps: ' + exercise.total_reps_array[index].toString(),
              context),
          _getIconAndText(
              Icons.category,
              'Score: ' + exercise.results[index].toString() + '%',
              context),
        ]));

        listViewItems.add(const Padding(padding: EdgeInsets.all(15)));

      }

      return Scaffold(
          body: Stack(
              children: <Widget>[
              ListView(
                padding: const EdgeInsets.only(bottom: 15.0),
                physics: const ClampingScrollPhysics(),
                children: <Widget>[
                  Image(image: AssetImage('assets/images/hip_adduction.jpg')),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                    children: listViewItems,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 60))
                ]
      )]));

    } else {
      return const CircularProgress(isLoading: true);
    }
  }

  String getDurationFormat() {
    final Duration duration = Duration(hours: exercise.sets.toInt());
    String sDuration = '';
    if (duration.inDays == 1) {
      sDuration = '${duration.inDays} day';
    } else if (duration.inDays > 1) {
      sDuration = '${duration.inDays} days';
    }
    if (duration.inHours.remainder(24) == 1) {
      sDuration = commaAdder(sDuration);
      sDuration = sDuration + '${duration.inHours.remainder(24)} hour';
    } else if (duration.inHours.remainder(24) > 1) {
      sDuration = commaAdder(sDuration);
      sDuration = sDuration + '${duration.inHours.remainder(24)} hours';
    }
    if (duration.inMinutes.remainder(60) == 1) {
      sDuration = commaAdder(sDuration);
      sDuration = sDuration + '${duration.inMinutes.remainder(60)} minute';
    } else if (duration.inMinutes.remainder(60) > 1) {
      sDuration = commaAdder(sDuration);
      sDuration = sDuration + '${duration.inMinutes.remainder(60)} minutes';
    }
    return sDuration;
  }

  String commaAdder(String sDuration) {
    if (sDuration.isNotEmpty) {
      sDuration = sDuration + ', ';
    }
    return sDuration;
  }

  Widget _getIconAndText(
      IconData headingIcon, String headingText, BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(headingIcon, size: 22.0),
        const Padding(padding: EdgeInsets.only(left: 5.0, right: 3.0)),
        Expanded(
            child: AutoSizeText(headingText,
                style: Theme.of(context).textTheme.body1))
      ],
    );
  }
}

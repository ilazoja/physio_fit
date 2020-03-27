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
  ResultDetail({Key key, @required this.exercise, @required this.index})
      : super(key: key);

  final CompletedExercise exercise;
  final int index;
  BuildContext context;
  ScaffoldState scaffoldState;

  Widget _appBar() {
    return AppBar(
      title: Text(
        'Daily Summary',
        style: TextStyle(
          color: const Color.fromRGBO(160, 187, 227, 1.0),
          fontFamily: 'OpenSans',
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: const Color(0xff2c4260),
      elevation: 0.0,
    );
  }

  Widget createBigCard(String textToOutput) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.99,
          height: MediaQuery.of(context).size.height * 0.2,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            color: const Color.fromRGBO(122, 223, 220, 1.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: Center(
                  child: Text(
                textToOutput.toString(),
                style: TextStyle(
                  color: const Color.fromRGBO(255, 255, 255, 1.0),
                  fontFamily: 'OpenSans',
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ),
          ),
        ));
  }

  Widget createSmallCards(String type, String textToOutput) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.99,
          height: MediaQuery.of(context).size.height * 0.1,
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              color: const Color.fromRGBO(122, 223, 220, 1.0),
              child: Row(
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width * 0.42,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.05,
                            MediaQuery.of(context).size.height * 0.03,
                            0.0,
                            0.0),
                        child: Text(
                          type.toString(),
                          style: TextStyle(
                            color: const Color.fromRGBO(255, 255, 255, 1.0),
                            fontFamily: 'OpenSans',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.3),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0,
                            MediaQuery.of(context).size.height * 0.03,
                            0.0,
                            0.0),
                        child: Text(
                          textToOutput.toString(),
                          style: TextStyle(
                            color: const Color.fromRGBO(255, 255, 255, 1.0),
                            fontFamily: 'OpenSans',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                ],
              )),
        ));
  }

  Widget threeDots(int indexToFill) {
    double width1, width2, width3;
    if (indexToFill == 0) {
      width1 = 3.0;
      width2 = 1.0;
      width3 = 1.0;
    } else if (indexToFill == 1) {
      width1 = 1.0;
      width2 = 3.0;
      width3 = 1.0;
    } else if (indexToFill == 2) {
      width1 = 1.0;
      width2 = 1.0;
      width3 = 3.0;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 20,
          height: 20,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xff2c4260),
              border: Border.all(
                  color: Colors.white, width: width1, style: BorderStyle.solid),
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          width: 20,
          height: 20,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xff2c4260),
              border: Border.all(
                  color: Colors.white, width: width2, style: BorderStyle.solid),
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          width: 20,
          height: 20,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xff2c4260),
              border: Border.all(
                  color: Colors.white, width: width3, style: BorderStyle.solid),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    final FirebaseUser firebaseUser = Provider.of<FirebaseUser>(context);

    if (exercise != null) {
      return PageView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          // Hip Abduction
          Scaffold(
              appBar: _appBar(),
              backgroundColor: const Color(0xff2c4260),
              body: Column(children: <Widget>[
                createBigCard(exercise.names[0]),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                createSmallCards(
                    'Sets',
                    exercise.h_sets.toString() +
                        '/' +
                        exercise.h_sets.toString()),
                createSmallCards(
                    'Correct Reps',
                    (exercise.correct_reps_h[index].toString() +
                            '/' +
                            exercise.attempted_h[index].toString())
                        .toString()),
                createSmallCards(
                    'Attemped Reps',
                    (exercise.attempted_h[index].toString() +
                            '/' +
                            exercise.attempted_h[index].toString())
                        .toString()),
                createSmallCards('Score',
                    (exercise.score_h[index].toString() + '%').toString()),
                SizedBox(height: MediaQuery.of(context).size.height * 0.19),
                threeDots(0),
              ])),
          // Knee Flexion
          Scaffold(
              appBar: _appBar(),
              backgroundColor: const Color(0xff2c4260),
              body: Column(children: <Widget>[
                createBigCard(exercise.names[1]),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                createSmallCards(
                    'Sets',
                    exercise.k_sets.toString() +
                        '/' +
                        exercise.k_sets.toString()),
                createSmallCards(
                    'Correct Reps',
                    (exercise.correct_reps_k[index].toString() +
                            '/' +
                            exercise.attempted_k[index].toString())
                        .toString()),
                createSmallCards(
                    'Attemped Reps',
                    (exercise.attempted_k[index].toString() +
                            '/' +
                            exercise.attempted_k[index].toString())
                        .toString()),
                createSmallCards('Score',
                    (exercise.score_k[index].toString() + '%').toString()),
                SizedBox(height: MediaQuery.of(context).size.height * 0.19),
                threeDots(1),
              ])),
          // Squats
          Scaffold(
              appBar: _appBar(),
              backgroundColor: const Color(0xff2c4260),
              body: Column(children: <Widget>[
                createBigCard(exercise.names[2]),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                createSmallCards(
                    'Sets',
                    exercise.s_sets.toString() +
                        '/' +
                        exercise.s_sets.toString()),
                createSmallCards(
                    'Correct Reps',
                    (exercise.correct_reps_s[index].toString() +
                            '/' +
                            exercise.attempted_s[index].toString())
                        .toString()),
                createSmallCards(
                    'Attemped Reps',
                    (exercise.attempted_s[index].toString() +
                            '/' +
                            exercise.attempted_s[index].toString())
                        .toString()),
                createSmallCards('Score',
                    (exercise.score_s[index].toString() + '%').toString()),
                SizedBox(height: MediaQuery.of(context).size.height * 0.19),
                threeDots(2),
              ])),
        ],
      );
    } else {
      return const CircularProgress(isLoading: true);
    }
  }

  //     if (exercise != null) {
  //       listViewItems.add(Wrap(runSpacing: 4.5, children: <Widget>[
  //         _getIconAndText(
  //             Icons.location_city, 'Name: ' + exercise.name, context),
  //         _getIconAndText(Icons.accessibility,
  //             'Sets: ' + exercise.sets.toString(), context),
  //         _getIconAndText(Icons.accessibility,
  //             'Time: ' + exercise.workout_time.toString(), context),
  //         _getIconAndText(
  //             Icons.accessibility,
  //             'Correct Reps: ' + exercise.correct_reps_array[index].toString(),
  //             context),
  //         _getIconAndText(
  //             Icons.category,
  //             'Attempted Reps: ' + exercise.total_reps_array[index].toString(),
  //             context),
  //         _getIconAndText(Icons.category,
  //             'Score: ' + exercise.results[index].toString() + '%', context),
  //       ]));

  //       listViewItems.add(const Padding(padding: EdgeInsets.all(15)));
  //     }

  //     return Scaffold(
  //         body: Stack(children: <Widget>[
  //       ListView(
  //           padding: const EdgeInsets.only(bottom: 15.0),
  //           physics: const ClampingScrollPhysics(),
  //           children: <Widget>[
  //             Image(image: AssetImage('assets/images/hip_adduction.jpg')),
  //             Container(
  //               padding: const EdgeInsets.all(20),
  //               child: Column(
  //                 children: listViewItems,
  //               ),
  //             ),
  //             const Padding(padding: EdgeInsets.only(bottom: 60))
  //           ])
  //     ]));
  //   } else {
  //     return const CircularProgress(isLoading: true);
  //   }
  // }

  // String getDurationFormat() {
  //   final Duration duration = Duration(hours: exercise.sets.toInt());
  //   String sDuration = '';
  //   if (duration.inDays == 1) {
  //     sDuration = '${duration.inDays} day';
  //   } else if (duration.inDays > 1) {
  //     sDuration = '${duration.inDays} days';
  //   }
  //   if (duration.inHours.remainder(24) == 1) {
  //     sDuration = commaAdder(sDuration);
  //     sDuration = sDuration + '${duration.inHours.remainder(24)} hour';
  //   } else if (duration.inHours.remainder(24) > 1) {
  //     sDuration = commaAdder(sDuration);
  //     sDuration = sDuration + '${duration.inHours.remainder(24)} hours';
  //   }
  //   if (duration.inMinutes.remainder(60) == 1) {
  //     sDuration = commaAdder(sDuration);
  //     sDuration = sDuration + '${duration.inMinutes.remainder(60)} minute';
  //   } else if (duration.inMinutes.remainder(60) > 1) {
  //     sDuration = commaAdder(sDuration);
  //     sDuration = sDuration + '${duration.inMinutes.remainder(60)} minutes';
  //   }
  //   return sDuration;
  // }

  // String commaAdder(String sDuration) {
  //   if (sDuration.isNotEmpty) {
  //     sDuration = sDuration + ', ';
  //   }
  //   return sDuration;
  // }

  // Widget _getIconAndText(
  //     IconData headingIcon, String headingText, BuildContext context) {
  //   return Row(
  //     children: <Widget>[
  //       Icon(headingIcon, size: 22.0),
  //       const Padding(padding: EdgeInsets.only(left: 5.0, right: 3.0)),
  //       Expanded(
  //           child: AutoSizeText(headingText,
  //               style: Theme.of(context).textTheme.body1))
  //     ],
  //   );
  // }
}

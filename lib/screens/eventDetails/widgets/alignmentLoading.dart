import 'dart:async';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'package:physio_tracker_app/imu_processing/exercise_recognizer.dart';
import 'package:physio_tracker_app/imu_processing/alignment_profile.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;
import 'package:physio_tracker_app/screens/eventDetails/widgets/imuAlignment.dart';

class AlignmentLoading extends StatefulWidget {
  AlignmentLoading(
    {Key key, @required this.exercise, @required this.angleMetadata})
    : super(key: key);

  Exercise exercise;
  Map<String, List<double>> angleMetadata;
  List<vector_math.Quaternion> sensorValues = <vector_math.Quaternion>[];

  @override
  _AlignmentLoadingState createState() => _AlignmentLoadingState();
}

class _AlignmentLoadingState extends State<AlignmentLoading> {
  Timer _timer;
  AlignmentProfile alignmentProfile;
  ExerciseRecognizer exerciseRecognizer;
  bool isReady;

  _AlignmentLoadingState() {
    _timer = Timer(const Duration(seconds: 10), () {
      setState(() {
      });
      goNewScreen();
    });
  }

  @override
  void initState() {
    super.initState();
    isReady = false;
    for(int i = 0; i < 5; i++)
    {
      widget.sensorValues.add(vector_math.Quaternion.identity());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void goNewScreen() {
    _timer.cancel();
    alignmentProfile = AlignmentProfile(widget.sensorValues[0], widget.sensorValues[3], widget.sensorValues[2], widget.sensorValues[1], widget.sensorValues[4]);
    exerciseRecognizer = ExerciseRecognizer(alignmentProfile);
    final int state = exerciseRecognizer.processIMU(widget.sensorValues[0], widget.sensorValues[3], widget.sensorValues[2], widget.sensorValues[1], widget.sensorValues[4]);
    isReady = true;
    Navigator.of(context, rootNavigator: true).push<dynamic>(DefaultPageRoute<dynamic>(
    pageRoute: ImuAlignment(
              alignmentProfile: alignmentProfile,
              angleMetadata: widget.angleMetadata,
              isReady: isReady,
              sensorValues: widget.sensorValues,
              exercise: widget.exercise,
              exerciseRecognizer: exerciseRecognizer,
              state: state
     )));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF73AEF5),
                  const Color(0xFF61A4F1),
                  const Color(0xFF478DE0),
                  const Color(0xFF398AE5),
                ],
               begin: const Alignment(0.5, -1.0),
                end: const Alignment(0.5, 1.0)
              )
            ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: () => goNewScreen(),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Padding (
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
                  child: SizedBox(
                    child: CircularProgressIndicator(backgroundColor: Colors.white),
                    height: 200.0,
                    width: 200.0,
                  )
                ),
                Padding (
                  padding: EdgeInsets.fromLTRB(20, 30, 0, 10),
                  child:
                  Text('Sensor Alignment Pending', style:
                    TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      decoration: TextDecoration.none
                    )
                )),
                Padding (
                  padding: EdgeInsets.fromLTRB(20, 30, 0, 10),
                  child:
                  Text('Please Stand Still', style:
                    TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      decoration: TextDecoration.none
                    )
                )),
                Padding (
                  padding: EdgeInsets.fromLTRB(20, 30, 0, 10),
                  child:
                  Text('Place Legs Shoulder Width Apart', style:
                    TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      decoration: TextDecoration.none
                    )
                )),
              ]
            ),
          )
        )
      ]
    );
  }
}
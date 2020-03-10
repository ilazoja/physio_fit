// Call function that returns bool
import 'dart:math';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:physio_tracker_app/copyDeck.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/widgets/shared/subHeading.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;
import 'dart:convert' show utf8;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:physio_tracker_app/imu_processing/alignment_profile.dart';
import 'package:physio_tracker_app/imu_processing/exercise_recognizer.dart';
import 'package:physio_tracker_app/widgets/shared/circular_progress.dart';


class ImuAlignment extends StatefulWidget {
  ImuAlignment({Key key,
          @required this.exercise,
          @required this.angleMetadata,
          @required this.isReady,
          @required this.alignmentProfile,
          @required this.sensorValues }) : super(key: key);

  Exercise exercise;
  final Map<String, List<double>> angleMetadata;
  bool isReady;
  List<vector_math.Quaternion> sensorValues;
  bool doneAlignment = false;

  static _ImuAlignmentState imuAlignmentState;
  AlignmentProfile alignmentProfile;

  @override
  _ImuAlignmentState createState() => generateState();


  _ImuAlignmentState generateState() {
    imuAlignmentState = _ImuAlignmentState();
    return imuAlignmentState;
  }
}

class _ImuAlignmentState extends State<ImuAlignment> {
  bool showMoreButtonPressed = false;

  @override
  void setState(VoidCallback fn) {
  }


  @override
  Widget build(BuildContext context) {
    ExerciseRecognizer exerciseRecognizer = ExerciseRecognizer(widget.alignmentProfile);
    widget.sensorValues[0] = vector_math.Quaternion(0.007202148437500,-0.715820312500000,0.003295898437500, 0.698242187500000);
    widget.sensorValues[1] = vector_math.Quaternion(0.006164550781250,0.016784667968750,0.709533691406250, 0.704467773437500);
    int state = exerciseRecognizer.processIMU(widget.sensorValues[0], widget.sensorValues[1], widget.sensorValues[2], widget.sensorValues[3], widget.sensorValues[4]);
    print(exerciseRecognizer.quatLeftRootToFemur);
    if(widget.isReady) {
      //print(widget.sensorValues[0].x.toString());
      //print(widget.sensorValues[1].y.toString());
    }
    if(!widget.isReady) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(alignment: AlignmentDirectional.center, children:  <Widget>[
              CircularProgressIndicator(strokeWidth: 14),
              SubHeading(
                heading: "IMU ALIGNMENT in Progress"
              ),
              SubHeading(
                heading: state.toString()
              ),
            ],
        ));
    }
    else {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(alignment: AlignmentDirectional.center, children:  <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                child: SubHeading(
                heading: state.toString()
              )),
            ],
      ));
    }
  }

   double roundDouble(double value, int places){
   final double mod = pow(10.0, places);
   return ((value * mod).round().toDouble()) / mod;
  }

  vector_math.Quaternion _dataParser(List<int> dataFromDevice) {
    final String quatString = utf8.decode(dataFromDevice);
    print("quatString");
    print(quatString);
    final List<String> quatList = quatString.split(',');
    final double w = roundDouble(double.tryParse(quatList[0]), 7) ?? 0;
    final double x = roundDouble(double.tryParse(quatList[1]), 7) ?? 0;
    final double y = roundDouble(double.tryParse(quatList[2]), 7) ?? 0;
    final double z = roundDouble(double.tryParse(quatList[3]), 7) ?? 0;

    return vector_math.Quaternion(x, y, z, w);
  }

  Widget createSubHeading(String subHeading) {
    return SliverToBoxAdapter(
        child: SubHeading(
          heading: subHeading,
        ));
  }



}
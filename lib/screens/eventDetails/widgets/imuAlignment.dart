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
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:oscilloscope/oscilloscope.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;


class ImuAlignment extends StatefulWidget {
  ImuAlignment({Key key,
          @required this.exercise,
          @required this.angleMetadata,
          @required this.isReady,
          @required this.alignmentProfile,
          @required this.exerciseRecognizer,
          @required this.state,
          @required this.sensorValues }) : super(key: key);

  Exercise exercise;
  final Map<String, List<double>> angleMetadata;
  bool isReady;
  List<vector_math.Quaternion> sensorValues;
  bool doneAlignment = false;

  static _ImuAlignmentState imuAlignmentState;
  AlignmentProfile alignmentProfile;
  ExerciseRecognizer exerciseRecognizer;
  int state;

  @override
  _ImuAlignmentState createState() => generateState();


  _ImuAlignmentState generateState() {
    imuAlignmentState = _ImuAlignmentState();
    return imuAlignmentState;
  }
}

class _ImuAlignmentState extends State<ImuAlignment> {
  bool showMoreButtonPressed = false;
  Timer _timer;
  List<Angles> angles = List();
  int counter = 0;

  dynamic _generateTrace(Timer t) {
    // generate our  values
    // Add to the growing dataset
    setState(() {
      print("ANGLES");
      print(angles);
    });

  }
  @override
  void setState(VoidCallback fn) {
  }

  @override
  initState() {
    super.initState();
    // create our timer to generate test values
    _timer = Timer.periodic(Duration(milliseconds: 60), _generateTrace);
  }


  @override
  Widget build(BuildContext context) {
    int state = widget.exerciseRecognizer.processIMU(widget.sensorValues[0], widget.sensorValues[3], widget.sensorValues[2], widget.sensorValues[1], widget.sensorValues[4]);
    counter += 1;
    angles.add(Angles(counter, widget.exerciseRecognizer.projXY_R_Femur_Ang));
    print(widget.exerciseRecognizer.projXY_R_Femur_Ang);
    double projXY_R_Femur_Ang = widget.exerciseRecognizer.projXY_R_Femur_Ang;
    double projYZ_R_Femur_Ang = widget.exerciseRecognizer.projYZ_R_Femur_Ang;
    double projXZ_R_Foot_Ang = widget.exerciseRecognizer.projXZ_R_Foot_Ang;
    double projXY_Root_Ang = widget.exerciseRecognizer.projXY_Root_Ang;
    double projYZ_Root_Ang = widget.exerciseRecognizer.projYZ_Root_Ang;
    vector.Quaternion quatWorldToRoot = widget.exerciseRecognizer.quatWorldToRoot;
    vector.Quaternion quatLeftRootToFemur = widget.exerciseRecognizer.quatLeftRootToFemur;
    if(widget.isReady) {
      //print(widget.sensorValues[0].x.toString());
      //print(widget.sensorValues[1].y.toString());
    }
    
    List<charts.Series<Angles, double>> graph = [
      charts.Series<Angles, double>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Angles ang, _) => ang.time.toDouble(),
        measureFn: (Angles angle, _) => angle.angle,
        data: angles,
      )
    ];
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
          body: 
              Column(
                children: <Widget>[
                  Expanded(child: charts.LineChart(graph, animate: true))
                ],
              )
      );
    }
  }

   double roundDouble(double value, int places){
   final double mod = pow(10.0, places);
   return ((value * mod).round().toDouble()) / mod;
  }

  vector_math.Quaternion _dataParser(List<int> dataFromDevice) {
    final String quatString = utf8.decode(dataFromDevice);

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

class Angles {
  final int time;
  final double angle;

  Angles(this.time, this.angle);
}
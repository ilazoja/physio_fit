import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:physio_tracker_app/screens/exercise-starting/explainIMU.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;

class ExerciseStartScreen extends StatefulWidget {
  @override
  _ExerciseStartScreenState createState() => _ExerciseStartScreenState();
}

class _ExerciseStartScreenState extends State<ExerciseStartScreen> {
  Exercise _exercise;
  static const String squat = 'assets/images/squat.png';
  static const String flexion = 'assets/images/knee.png';
  static const String adduction = 'assets/images/hip.png';

  Future<bool> navigateBack() {
    return showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want to skip your exercises?'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No')),
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Yes')),
              ],
            ) ??
            false);
  }

  Widget _appBar() {
    return AppBar(
      title: Text(
        'Exercise Session',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'OpenSans',
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: const Color(0xFF73AEF5),
      elevation: 0.0,
    );
  }

  Widget _topText() {
    return Column(
      children: <Widget>[
        Text(
          'EXERCISE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w100,
            fontSize: 17.0,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _exerciseType() {
    return Column(
      children: <Widget>[
        Text(
          _exercise.name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 50.0,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _exerciseInfo() {
    return Column(
      children: <Widget>[
        Text(
          _exercise.sets.toString() + ' sets',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w100,
            fontSize: 15.0,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8.0),
        Text(
          _exercise.repetitions.toString() + ' reps',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w100,
            fontSize: 15.0,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8.0),
        Text(
          '10 seconds',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w100,
            fontSize: 15.0,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _playButton() {
    return RawMaterialButton(
      onPressed: () {
        Navigator.of(context, rootNavigator: true)
        .push<dynamic>(DefaultPageRoute<dynamic>(
        pageRoute: ExplainImu(exercise: _exercise, angleMetadata: copy.angleMetaData)));},
      child: Icon(
        Icons.play_arrow,
        color: Colors.white,
        size: 60.0,
      ),
      shape: const CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.green,
      padding: const EdgeInsets.all(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    _exercise = Provider.of<Exercise>(context);
    String imageUrl = "";

    if (_exercise != null) {
      if (_exercise.type.toLowerCase() == "squat") {
        imageUrl = squat;
      }
      else if (_exercise.type.toLowerCase() == "flexion") {
        imageUrl = flexion;
      }
      else {
        imageUrl = adduction;
      }
    }
    return WillPopScope(
      onWillPop: navigateBack,
      child: Scaffold(
        appBar: _appBar(),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF73AEF5),
                        const Color(0xFF61A4F1),
                        const Color(0xFF478DE0),
                        const Color(0xFF398AE5),
                      ],
                      stops: [0.1, 0.4, 0.7, 0.9],
                    ),
                  ),
                ),
                Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 10.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      Center(
                        child: _topText(),
                      ),
                      const SizedBox(height: 15.0),
                      Center(
                        child: _exerciseType(),
                      ),
                      const SizedBox(height: 20.0),
                      Center(
                        child: _exerciseInfo(),
                      ),
                      const SizedBox(height: 50.0),
                      Container(
                        width: 200.0,
                        height: 200.0,
                        child: Image(image: AssetImage(imageUrl)),
                      ),
                      const SizedBox(height: 50.0),
                      _playButton(),
                    ],
                  ),
                ),
              ),
              ]
            )
          )
        )
      )
    );
  }
}
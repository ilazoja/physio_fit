import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'addNextImuButton.dart';
import 'donning5Sensor2.dart';

class Donning5Sensor1 extends StatelessWidget
{
  const Donning5Sensor1(
    {Key key, @required this.exercise, @required this.angleMetadata})
    : super(key: key);

  final Exercise exercise;
  final Map<String, List<double>> angleMetadata;

  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      appBar: AppBar(
        title: const Text('Place IMU Straps on Body'),
        backgroundColor: Colors.white,
      ),
      body: Container (
        child: Center(
          child: Column (
            children: <Widget>[
              Image.asset(
                'assets/imuDonning/chest_sensor_location.png',
                fit: BoxFit.fill,
                width: (MediaQuery.of(context).size.width) * 0.6,
                height: (MediaQuery.of(context).size.height) * 0.65,
              ),
              const Card (
                child: ListTile(
                  title: Text('1. Put the IMU sensor on your Chest'),
                ),
              ),
              AddNextImuButton (
                buttonText: 'Next Step',
                 callback:() {
                  Navigator.of(context, rootNavigator: true)
                  .push<dynamic>(DefaultPageRoute<dynamic>(
                  pageRoute: Donning5Sensor2(exercise: exercise, angleMetadata: angleMetadata)));
                }
              )
            ],
          )
        ),
      )
    );
  }
}
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'addNextImuButton.dart';
import 'donning3Sensor3.dart';

class Donning3Sensor2 extends StatelessWidget
{
  const Donning3Sensor2(
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
                'assets/imuDonning/right_thigh_three_sensor_location.png',
                fit: BoxFit.fill,
                width: (MediaQuery.of(context).size.width) * 0.6,
                height: (MediaQuery.of(context).size.height) * 0.65,
              ),
              const Card (
                child: ListTile(
                  title: Text('2. Put the IMU sensor on your right thigh'),
                ),
              ),
              AddNextImuButton (
                buttonText: 'Next Step',
                 callback:() {
                  Navigator.of(context, rootNavigator: true)
                  .push<dynamic>(DefaultPageRoute<dynamic>(
                  pageRoute: Donning3Sensor3(exercise: exercise, angleMetadata: angleMetadata)));
                }
              )
            ],
          )
        ),
      )
    );
  }
}
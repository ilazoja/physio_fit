import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/screens/eventDetails/widgets/donning5Sensor1.dart';
import 'package:physio_tracker_app/screens/exercise-starting/nextButton.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'assetsImages.dart';
import 'circles_with_images.dart';

class ExplainImu extends StatelessWidget
{
  const ExplainImu(
    {Key key, @required this.exercise, @required this.angleMetadata})
    : super(key: key);

  final Exercise exercise;
  final Map<String, List<double>> angleMetadata;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Stack(
        children: <Widget>[
          Positioned(
            child: CircleWithImage(Assets.pose1),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: (MediaQuery.of(context).size.height)*0.28,
                ),
                SizedBox(
                  child: Image(
                    image: AssetImage(Assets.pose1),
                    fit: BoxFit.fitHeight,
                  ),
                  height: IMAGE_SIZE,
                  width: IMAGE_SIZE,
                ),
                Text('Place Sensors on Body',
                    style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0,0,0,(MediaQuery.of(context).size.height)*0.05),
                  child: Text('Make Sure You Have Retreived \n Your Sensors Before Moving On!',
                              style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
                              textAlign: TextAlign.center,
                              ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 200,
                    height: 130,
                    child: NextButton(
                      buttonText: 'Ready',
                      scaleFactor: 1.8,
                      callback: () =>
                            Navigator.of(context, rootNavigator: true).push<dynamic>(DefaultPageRoute<dynamic>(
                            pageRoute: Donning5Sensor1(exercise: exercise, angleMetadata: angleMetadata))),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
        alignment: FractionalOffset.center,
      ),
    );
  }
}
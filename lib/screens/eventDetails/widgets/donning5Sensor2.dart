import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/screens/exercise-starting/circles_with_images.dart';
import 'package:physio_tracker_app/screens/exercise-starting/assetsImages.dart';
import 'package:physio_tracker_app/screens/exercise-starting/nextButton.dart';
import 'donning5Sensor3.dart';

class Donning5Sensor2 extends StatelessWidget
{
  const Donning5Sensor2(
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
            child: CircleWithImage(Assets.pose3),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: (MediaQuery.of(context).size.height)*0.04,
                ),
                SizedBox(
                  child: Image(
                    image: AssetImage(Assets.pose3),
                    fit: BoxFit.fitHeight,
                  ),
                  height: IMAGE_SIZE*2.0,
                  width: IMAGE_SIZE*2.0,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0,(MediaQuery.of(context).size.height)*0.01,0,(MediaQuery.of(context).size.height)*0.01),
                  child: Text('Place the IMU sensor \n on your left thigh.',
                              style: Theme.of(context).textTheme.headline.copyWith(color: Colors.white),
                              textAlign: TextAlign.center,
                              ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 200,
                    height: 100,
                    child: NextButton(
                      buttonText: 'Next Step',
                      scaleFactor: 1.4,
                      callback: () =>
                            Navigator.of(context, rootNavigator: true).push<dynamic>(DefaultPageRoute<dynamic>(
                            pageRoute: Donning5Sensor3(exercise: exercise, angleMetadata: angleMetadata))),
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
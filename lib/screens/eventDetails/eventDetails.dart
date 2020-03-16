import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:physio_tracker_app/screens/eventDetails/eventDetailsButton.dart';
import 'package:physio_tracker_app/themeData.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/widgets/shared/circular_progress.dart';

import 'package:physio_tracker_app/screens/eventDetails/widgets'
    '/moreDateEventsScrolling.dart';

import '../../models/event.dart';
import '../../models/user.dart';
import '../../models/exercise.dart';
import '../../services/cloud_database.dart';
import 'widgets/carouselWrapper.dart';
import 'widgets/eventDetailsHeading.dart';
import 'widgets/eventDetailsItems.dart';

class EventDetails extends StatefulWidget {
  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails>
    with TickerProviderStateMixin {
  Exercise _exercise;
  bool _loggedIn;
  bool _hostingEvent;
  FirebaseUser _user;
  AnimationController _colorAnimationController;
  Animation<Color> _colorTween, _colorTweenTitle;
  double _elevation = 0.0;
  DateTime cancelByDate;

  static const String squat = 'assets/images/squats.png';
  static const String flexion = 'assets/images/knee_flexion_extension.jpg';
  static const String adduction = 'assets/images/hip_adduction.jpg';


  @override
  void initState() {
    _colorAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 0));
    _colorTween = ColorTween(begin: Colors.transparent, end: mainColor)
        .animate(_colorAnimationController);
    _colorTweenTitle = ColorTween(begin: Colors.transparent, end: Colors.white)
        .animate(_colorAnimationController);
    super.initState();
  }

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimationController.animateTo(scrollInfo.metrics.pixels / 100);
      if (scrollInfo.metrics.pixels > 300) {
        //Animation doesn't work well with elevation
        _elevation = 5.0;
      } else {
        _elevation = 0.0;
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    _exercise = Provider.of<Exercise>(context);
    print(_exercise.repetitions);
    print(_exercise.sets);
    print(_exercise.type);
    _user = Provider.of<FirebaseUser>(context);
    final List<dynamic> _allImages = <dynamic>[];
    String imageUrl = "";
    if (_exercise != null) {
      _loggedIn = _user != null;
      if (_exercise.type.toLowerCase() == "squat") {
        imageUrl = squat;
      }
      else if (_exercise.type.toLowerCase() == "flexion") {
        imageUrl = flexion;
      }
      else {
        imageUrl = adduction;
      }
      print(_allImages);
      return Scaffold(
          body: Stack(
        children: <Widget>[
          NotificationListener<ScrollNotification>(
            onNotification: _scrollListener,
            child: Stack(
              children: <Widget>[
                ListView(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    physics: const ClampingScrollPhysics(),
                    children: <Widget>[
                      Image(image: AssetImage(imageUrl)),
                      StreamProvider<User>.value(
                        value: CloudDatabase.streamUserById(_user.uid),
                        child: EventDetailsItems(
                            exercise: _exercise),
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 60))
                    ]),
                Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    height: MediaQuery.of(context).padding.top + 50,
                    child: AnimatedBuilder(
                        animation: _colorAnimationController,
                        builder: (BuildContext context, Widget child) =>
                            Stack(children: <Widget>[
                              AppBar(
                                brightness: Brightness.dark,
                                automaticallyImplyLeading: false,
                                backgroundColor: _colorTween.value,
                                elevation: _elevation,
                                titleSpacing: 2.0,
                              ),
                              Container(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).padding.top),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      IconButton(
                                        splashColor: Colors.transparent,
                                        onPressed: () => Navigator.pop(context),
                                        icon: Icon(Icons.arrow_back_ios,
                                            color: Colors.white),
                                      ),
                                      Expanded(
                                        child: AutoSizeText(
                                          _exercise.name,
                                          maxLines: 1,
                                          minFontSize: 20,
                                          overflow: TextOverflow.clip,
                                          style: Theme.of(context)
                                              .appBarTheme
                                              .textTheme
                                              .title
                                              .copyWith(
                                                  color:
                                                      _colorTweenTitle.value),
                                        ),
                                      )
                                    ],
                                  ))
                            ])))
              ],
            ),
          )
        ],
      ));
    } else {
      return const Scaffold(body: CircularProgress(isLoading: true));

    }
  }

  Widget _getImageOverlayText() {
    return Container(
        //Heading details
        height: (MediaQuery.of(context).size.height) / 1.9,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Wrap(runSpacing: 5, children: <Widget>[
          _loggedIn
              ? StreamProvider<User>.value(
                  value: CloudDatabase.streamUser(_user.uid),
                  child: EventDetailsHeading(exercise: _exercise),
                )
              : EventDetailsHeading(exercise: _exercise),
          AutoSizeText(
             _exercise.name,
            style: Theme.of(context)
                .textTheme
                .display4
                .copyWith(fontStyle: FontStyle.italic),
          ),
        ]));
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:physio_tracker_app/screens/eventDetails/eventDetailsButton.dart';
// import 'package:physio_tracker_app/themeData.dart';
// import 'package:provider/provider.dart';
// import 'package:physio_tracker_app/widgets/shared/circular_progress.dart';
// import 'package:physio_tracker_app/screens/exercise-starting/assetsImages.dart';
// import 'package:physio_tracker_app/screens/exercise-starting/circles_with_images.dart';
// import 'package:physio_tracker_app/screens/exercise-starting/goBackButton.dart';
// import 'package:physio_tracker_app/screens/exercise-starting/nextButton.dart';
// import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
// import 'package:physio_tracker_app/screens/exercise-starting/explainIMU.dart';
// import 'package:physio_tracker_app/copyDeck.dart' as copy;

// import '../../models/event.dart';
// import '../../models/user.dart';
// import '../../models/exercise.dart';
// import '../../services/cloud_database.dart';
// import 'widgets/carouselWrapper.dart';
// import 'widgets/eventDetailsHeading.dart';
// import 'widgets/eventDetailsItems.dart';

// class EventDetails extends StatefulWidget {
//   @override
//   _EventDetailsState createState() => _EventDetailsState();
// }

// class _EventDetailsState extends State<EventDetails>
//     with TickerProviderStateMixin {
//   Exercise _exercise;
//   bool _loggedIn;
//   bool _hostingEvent;
//   FirebaseUser _user;
//   AnimationController _colorAnimationController;
//   Animation<Color> _colorTween, _colorTweenTitle;
//   double _elevation = 0.0;
//   DateTime cancelByDate;

//   static const String squat = 'assets/images/squats.png';
//   static const String flexion = 'assets/images/knee_flexion_extension.jpg';
//   static const String adduction = 'assets/images/hip_adduction.jpg';


//   @override
//   void initState() {
//     _colorAnimationController =
//         AnimationController(vsync: this, duration: const Duration(seconds: 0));
//     _colorTween = ColorTween(begin: Colors.transparent, end: mainColor)
//         .animate(_colorAnimationController);
//     _colorTweenTitle = ColorTween(begin: Colors.transparent, end: Colors.white)
//         .animate(_colorAnimationController);
//     super.initState();
//   }

//   bool _scrollListener(ScrollNotification scrollInfo) {
//     if (scrollInfo.metrics.axis == Axis.vertical) {
//       _colorAnimationController.animateTo(scrollInfo.metrics.pixels / 100);
//       if (scrollInfo.metrics.pixels > 300) {
//         //Animation doesn't work well with elevation
//         _elevation = 5.0;
//       } else {
//         _elevation = 0.0;
//       }
//       return true;
//     }
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//         children: <Widget>[
//           Container(
//             height: double.infinity,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.green[400],
//                   Colors.blue[600],
//                   Colors.blue[900],
//                 ],
//                begin: const Alignment(0.5, -1.0),
//                 end: const Alignment(0.5, 1.0)
//               )
//             ),
//           ),
//           Positioned(
//             left: 0.0,
//             top: 0.0,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: <Widget>[
//                   GoBackButton(callback: () => Navigator.pop(context)),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(9,0,0,18),
//                     child: Text('Exercise Session',
//                     style: Theme.of(context).textTheme.headline.copyWith(color: Colors.white),
//                     textAlign: TextAlign.center,
//                     ),
//                   )
//               ])
//             ),
//           ),
//           Positioned.fill(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(0,250,0,0),
//                   child: Text('Exercise 1',
//                     style: Theme.of(context).textTheme.body2.copyWith(color: Colors.white),
//                     textAlign: TextAlign.center,
//                     ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(0,0,0,300),
//                   child: Text('Hip \n Abduction',
//                     style: Theme.of(context).textTheme.display4.copyWith(color: Colors.white),
//                     textAlign: TextAlign.center,
//                     ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     width: 200,
//                     height: 130,
//                     child: NextButton(
//                       buttonText: 'Ready',
//                       scaleFactor: 1.8,
//                       callback: () =>
//                             Navigator.of(context, rootNavigator: true).push<dynamic>(DefaultPageRoute<dynamic>(
//                             pageRoute: ExplainImu(exercise: _exercise, angleMetadata: copy.angleMetaData))),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//         alignment: FractionalOffset.center,
//       );
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //     return Scaffold(
//   //         body: Stack(
//   //       children: <Widget>[
//   //         NotificationListener<ScrollNotification>(
//   //           onNotification: _scrollListener,
//   //           child: Stack(
//   //             children: <Widget>[
//   //               ListView(
//   //                   padding: const EdgeInsets.only(bottom: 15.0),
//   //                   physics: const ClampingScrollPhysics(),
//   //                   children: <Widget>[
//   //                     Image(image: AssetImage(imageUrl)),
//   //                     StreamProvider<User>.value(
//   //                       value: CloudDatabase.streamUserById(_user.uid),
//   //                       child: EventDetailsItems(
//   //                           exercise: _exercise),
//   //                     ),
//   //                     const Padding(padding: EdgeInsets.only(bottom: 60))
//   //                   ]),
//   //               Positioned(
//   //                   top: 0.0,
//   //                   left: 0.0,
//   //                   right: 0.0,
//   //                   height: MediaQuery.of(context).padding.top + 50,
//   //                   child: AnimatedBuilder(
//   //                       animation: _colorAnimationController,
//   //                       builder: (BuildContext context, Widget child) =>
//   //                           Stack(children: <Widget>[
//   //                             AppBar(
//   //                               brightness: Brightness.dark,
//   //                               automaticallyImplyLeading: false,
//   //                               backgroundColor: _colorTween.value,
//   //                               elevation: _elevation,
//   //                               titleSpacing: 2.0,
//   //                             ),
//   //                             Container(
//   //                                 padding: EdgeInsets.only(
//   //                                     top: MediaQuery.of(context).padding.top),
//   //                                 child: Row(
//   //                                   mainAxisAlignment: MainAxisAlignment.start,
//   //                                   crossAxisAlignment:
//   //                                       CrossAxisAlignment.center,
//   //                                   children: <Widget>[
//   //                                     IconButton(
//   //                                       splashColor: Colors.transparent,
//   //                                       onPressed: () => Navigator.pop(context),
//   //                                       icon: Icon(Icons.arrow_back_ios,
//   //                                           color: Colors.white),
//   //                                     ),
//   //                                     Expanded(
//   //                                       child: AutoSizeText(
//   //                                         _exercise.name,
//   //                                         maxLines: 1,
//   //                                         minFontSize: 20,
//   //                                         overflow: TextOverflow.clip,
//   //                                         style: Theme.of(context)
//   //                                             .appBarTheme
//   //                                             .textTheme
//   //                                             .title
//   //                                             .copyWith(
//   //                                                 color:
//   //                                                     _colorTweenTitle.value),
//   //                                       ),
//   //                                     )
//   //                                   ],
//   //                                 ))
//   //                           ])))
//   //             ],
//   //           ),
//   //         )
//   //       ],
//   //     ));
//   //   } else {
//   //     return const Scaffold(body: CircularProgress(isLoading: true));

//   //   }
//   // }
// }

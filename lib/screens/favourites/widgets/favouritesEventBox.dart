import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/models/completed_exercise.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:physio_tracker_app/screens/eventDetails/widgets/favouriteButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/models/event.dart';
import 'package:physio_tracker_app/screens/eventDetails/providerWrapper/eventDetailsProviderWrapper.dart';
import 'package:physio_tracker_app/screens/results/providerWrapper/resultsProviderWrapper.dart';

class FavouritesEventBox extends StatelessWidget {
  const FavouritesEventBox({@required this.event});

  final CompletedExercise event;

  static const String squat = 'assets/images/squats.png';
  static const String flexion = 'assets/images/knee_flexion_extension.jpg';
  static const String adduction = 'assets/images/hip_adduction.png';

  @override
  Widget build(BuildContext context) {
    final FirebaseUser _currUser = Provider.of<FirebaseUser>(context);

    String imageurl = "";
    if (event.name.toLowerCase() == "squat") {
      imageurl = squat;
    } else if (event.name.toLowerCase() == "flexion") {
      imageurl = flexion;
    } else {
      imageurl = adduction;
    }

    Widget createCard() {
      return Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Container(
              width: MediaQuery.of(context).size.width * 0.99,
              height: MediaQuery.of(context).size.height * 0.5,
              child: GestureDetector(
                onTap: () => Navigator.of(context).push<dynamic>(
                    DefaultPageRoute<dynamic>(
                        pageRoute: ResultsProviderWrapper(exercise: event))),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  color: const Color.fromRGBO(35, 35, 63, 1.0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: Center(
                        child: Column(
                      children: <Widget>[
                        const ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0)),
                            child: Image(
                                image: AssetImage('assets/images/bars.png'))),
                        const SizedBox(height: 8),
                        Text(
                          'View Weekly Summary',
                          style: TextStyle(
                            color: const Color.fromRGBO(255, 255, 255, 1.0),
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )),
                  ),
                ),
              )));
    }

    return createCard();

    return SafeArea(
      child: Card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.all(10),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.0),
          topRight: Radius.circular(5.0),
          bottomLeft: Radius.circular(5.0),
          bottomRight: Radius.circular(5.0),
        )),
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            print('this is starting14');
            Navigator.of(context).push<dynamic>(DefaultPageRoute<dynamic>(
                pageRoute: ResultsProviderWrapper(exercise: event)));
          },
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: Image(image: AssetImage(imageurl))),
                  Container(
                    padding: const EdgeInsets.only(top: 5.0),
                    alignment: Alignment.topRight,
                    child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: FavouriteButton(
                            eventId: event.id,
                            loggedIn: true,
                            size: 22.0,
                            notSelectedIcon: Icons.favorite,
                            notSelectedIconColor: Colors.white)),
                  )
                ],
              ),
              Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.only(
                      left: 20.0, top: 20.0, right: 6.0, bottom: 5),
                  child: AutoSizeText(event.name,
                      style: Theme.of(context)
                          .textTheme
                          .display3
                          .copyWith(color: Colors.black, fontSize: 25),
                      minFontSize:
                          Theme.of(context).textTheme.display3.fontSize,
                      maxLines: 2)),
              Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.only(
                      left: 20.0, bottom: 0.5, right: 6.0),
                  child: AutoSizeText(
                    event.name,
                    style: Theme.of(context)
                        .textTheme
                        .display2
                        .copyWith(color: Colors.black, fontSize: 15),
                    maxLines: 1,
                    textAlign: TextAlign.left,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  String _getNumberDollarSigns(double price) {
    if (price <= 0) {
      return 'Free';
    } else if (price > 0 && price < 10) {
      return '\$';
    } else if (price >= 10 && price <= 40) {
      return '\$\$';
    } else {
      return '\$\$\$';
    }
  }
}

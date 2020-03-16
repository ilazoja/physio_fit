import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:physio_tracker_app/screens/eventDetails/widgets/favouriteButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/models/event.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/screens/eventDetails/index.dart';
import 'package:intl/intl.dart';

class EventBox extends StatelessWidget {
  EventBox({
    @required this.exercise,
    @required this.setSmall,
    this.detailsPage,
  });

  final Exercise exercise;
  final bool setSmall;
  bool detailsPage;
  static const String squat = 'assets/images/squats.png';
  static const String flexion = 'assets/images/knee_flexion_extension.jpg';
  static const String adduction = 'assets/images/hip_adduction.png';

  @override
  Widget build(BuildContext context) {
    detailsPage ??= false;
    DateTime savedDateTime;
    final FirebaseUser _currUser = Provider.of<FirebaseUser>(context);
    final bool _loggedIn = _currUser != null;
    const double favouriteButtonSize = 20.0;



    String imageurl = "";
    if (exercise.type.toLowerCase() == "squat") {
      imageurl = squat;
    }
    else if (exercise.type.toLowerCase() == "flexion") {
      imageurl = flexion;
    }
    else {
      imageurl = adduction;
    }

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(2),
        topRight: Radius.circular(2),
        bottomLeft: Radius.circular(2),
        bottomRight: Radius.circular(2),
      )),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          //Change event model only when going to event, or will change
          // current page date as well
          print('this is starting15');
          Navigator.of(context).push<dynamic>(DefaultPageRoute<dynamic>(
              pageRoute: EventDetailsProviderWrapper(exercise: exercise)));
        },
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: setSmall ? 200 : 150,
                  width: MediaQuery.of(context).size.width,
                  child: Image(image: AssetImage(imageurl))
                ),
                !detailsPage
                    ? Container(
                        padding: const EdgeInsets.only(top: 5.0),
                        alignment: Alignment.topRight,
                        child: Container(
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                                child: _loggedIn
                                    ? StreamProvider<User>.value(
                                        value: CloudDatabase.streamUser(
                                            _currUser.uid),
                                        child: getFavouriteButton(_loggedIn,
                                            favouriteButtonSize, exercise.id),
                                      )
                                    : getFavouriteButton(_loggedIn,
                                        favouriteButtonSize, exercise.id))),
                      )
                    : Container()
              ],
            ),
            Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.only(
                    left: 6.0, top: 10.0, right: 6.0, bottom: 0.5),
                child: AutoSizeText(exercise.name,
                    style: Theme.of(context).textTheme.display3.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w600),
                    minFontSize: Theme.of(context).textTheme.display3.fontSize,
                    maxLines: setSmall ? 1 : 2)),
          ],
        ),
      ),
    );
  }

  Widget getFavouriteButton(bool loginState, double size, String eventId) {
    return FavouriteButton(
        eventId: eventId,
        loggedIn: loginState,
        size: size,
        notSelectedIcon: Icons.favorite,
        notSelectedIconColor: Colors.white);
  }
}

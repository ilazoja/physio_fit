import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physio_tracker_app/screens/eventDetails/providerWrapper/guestListProviderWrapper.dart';
import 'package:physio_tracker_app/screens/inbox/providerWrapper/chatScreenProviderWrapper.dart';
import 'package:physio_tracker_app/screens/eventDetails/widgets/announcementDialog.dart';
import 'package:physio_tracker_app/widgets/shared/circular_progress.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:physio_tracker_app/widgets/events/getIconAndHeadingRow.dart';
import 'package:physio_tracker_app/widgets/events/getItemTextRow.dart';
import 'package:physio_tracker_app/screens/patientDetails/widgets/addExerciseButton.dart';
import 'performExercise.dart';

import '../../../copyDeck.dart' as copy;
import '../../../models/exercise.dart';
import '../../../models/user.dart';

class EventDetailsItems extends StatelessWidget {
  EventDetailsItems(
      {Key key, @required this.exercise })
      : super(key: key);

  final Exercise exercise;
  BuildContext context;
  ScaffoldState scaffoldState;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    scaffoldState = Scaffold.of(context);
    final User _hostUser = Provider.of<User>(context);
    final FirebaseUser firebaseUser = Provider.of<FirebaseUser>(context);

    if (_hostUser != null) {
      final bool isHost =
          firebaseUser != null && firebaseUser.uid == _hostUser.id;

      final List<Widget> listViewItems = <Widget>[];

      if (exercise != null) {
        listViewItems.add(Wrap(runSpacing: 4.5, children: <Widget>[
          _getIconAndText(Icons.location_city, 'Name: ' + exercise.name, context),
          _getIconAndText(
              Icons.accessibility,
              'Sets: ' + exercise.sets.toString(),
              context),
          _getIconAndText(
              Icons.accessibility,
              'Repetitions: ' + exercise.repetitions.toString(),
              context),
          _getIconAndText(Icons.calendar_today,
              'Date: ' + exercise.date.toString(), context),
          _getIconAndText(
              Icons.category,
              'Type: ' + exercise.type,
              context),
        ]));

        // Event Durati

        listViewItems.add(const Padding(padding: EdgeInsets.all(15)));


//      //reviews
//      if (event.reviews.isNotEmpty) {
//        listViewItems.add(_getIconAndHeadingRow(
//            Icons.rate_review, copy.reviewsText, context));
//        for (String _review in event.reviews) {
//          listViewItems.add(_getItemTextRow(_review, context));
//        }
//      }
        listViewItems.add(AddExerciseButton(
            buttonText: "Start Exercise",
            callback: () {
              Navigator.of(context, rootNavigator: true)
                  .push<dynamic>(DefaultPageRoute<dynamic>(
                  pageRoute: PerformExercise(buttonText: "Perform Exercise", callback: (){},)));
            }),);
      }

      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: listViewItems,
        ),
      );
    } else {
      return const CircularProgress(isLoading: true);
    }
  }

  /*
  Widget contactHostRow(BuildContext context, FirebaseUser firebaseUser,
      User _hostUser, String _contactType) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(29, 0, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
              child: Icon(Icons.phone, color: Theme.of(context).accentColor),
              onTap: () => launch(_contactType + event.hostContact)),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: GestureDetector(
                child:
                    Icon(Icons.message, color: Theme.of(context).accentColor),
                onTap: () => Navigator.of(context).push<dynamic>(
                    DefaultPageRoute<dynamic>(
                        pageRoute: ChatScreenProviderWrapper(
                            id: firebaseUser.uid,
                            peerId: _hostUser.id,
                            peerName: _hostUser.displayName,
                            peerAvatar: _hostUser.profileImage)))),
          )
        ],
      ),
    );
  }
*/
  String getDurationFormat() {
    final Duration duration = Duration(hours: exercise.repetitions.toInt());
    String sDuration = '';
    if (duration.inDays == 1) {
      sDuration = '${duration.inDays} day';
    } else if (duration.inDays > 1) {
      sDuration = '${duration.inDays} days';
    }
    if (duration.inHours.remainder(24) == 1) {
      sDuration = commaAdder(sDuration);
      sDuration = sDuration + '${duration.inHours.remainder(24)} hour';
    } else if (duration.inHours.remainder(24) > 1) {
      sDuration = commaAdder(sDuration);
      sDuration = sDuration + '${duration.inHours.remainder(24)} hours';
    }
    if (duration.inMinutes.remainder(60) == 1) {
      sDuration = commaAdder(sDuration);
      sDuration = sDuration + '${duration.inMinutes.remainder(60)} minute';
    } else if (duration.inMinutes.remainder(60) > 1) {
      sDuration = commaAdder(sDuration);
      sDuration = sDuration + '${duration.inMinutes.remainder(60)} minutes';
    }
    return sDuration;
  }

  String commaAdder(String sDuration) {
    if (sDuration.isNotEmpty) {
      sDuration = sDuration + ', ';
    }
    return sDuration;
  }

  /*

  void guestListCallBack() {
    Navigator.of(context).push<dynamic>(DefaultPageRoute<dynamic>(
        pageRoute: GuestListProviderWrapper(eventId: event.id)));
  }
  */

  /*

  Future<void> _displayDialog() async {
    return showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return AnnouncementDialog(event: event, scaffoldState: scaffoldState);
        });
  }
*/
  String _getContactType(String hostContact) {
    if (_isNumeric(hostContact)) {
      return 'tel://';
    } else {
      return 'mailto://';
    }
  }

  Widget _getDivider() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: const Divider());
  }

  Widget _getIconAndText(
      IconData headingIcon, String headingText, BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(headingIcon, size: 22.0),
        const Padding(padding: EdgeInsets.only(left: 5.0, right: 3.0)),
        Expanded(
            child: AutoSizeText(headingText,
                style: Theme.of(context).textTheme.body1))
      ],
    );
  }

  Widget _getRowAndAction(IconData headingIcon, String headingText,
      BuildContext context, Function callback) {
    return GestureDetector(
      onTap: () => callback(),
      child: Row(
        children: <Widget>[
          Icon(headingIcon),
          const Padding(padding: EdgeInsets.only(left: 5.0)),
          AutoSizeText(headingText,
              style: Theme.of(context).textTheme.display4),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child:
                Icon(Icons.arrow_forward, color: Theme.of(context).accentColor),
          )
        ],
      ),
    );
  }

  bool _isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  Widget _getCancelledEvent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Row(
        children: <Widget>[
          Expanded(
              child: AutoSizeText(
            copy.eventHasBeenCancelled,
            style: Theme.of(context).textTheme.display4,
            maxLines: 3,
            minFontSize: 20,
          ))
        ],
      ),
    );
    return Container(
      child: Expanded(
        child: AutoSizeText(
          copy.eventHasBeenCancelled,
          style: Theme.of(context).textTheme.display4,
          maxLines: 2,
          minFontSize: 18,
        ),
      ),
    );
  }
}

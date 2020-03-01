import 'package:flutter/material.dart';
import 'package:physio_tracker_app/widgets/shared/standardButton.dart';
import 'package:physio_tracker_app/widgets/shared/circularProgressDialog.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'package:physio_tracker_app/widgets/login/loginDialog.dart';
import 'package:physio_tracker_app/screens/eventCreation/eventCreation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/services/email.dart';
import 'package:physio_tracker_app/helpers/stringHelper.dart';
import 'package:physio_tracker_app/dbKeys.dart' as db_key;
import '../../copyDeck.dart' as copy;
import '../../models/event.dart';
import '../../models/user.dart';
import '../../services/cloud_database.dart';
import '../eventConfirmation/index.dart';

class EventDetailsButton extends StatelessWidget {
  const EventDetailsButton(
      {@required this.loggedIn,
      @required this.hostingEvent,
      @required this.user,
      @required this.event,
      @required this.cancelByDate});

  final bool loggedIn;
  final bool hostingEvent;
  final FirebaseUser user;
  final Event event;
  final DateTime cancelByDate;

  @override
  Widget build(BuildContext context) {
    if (loggedIn) {
      final bool isBookedAndCancellable = event.guestIds.contains(user.uid) &&
              (cancelByDate != null && cancelByDate.isAfter(DateTime.now())) ||
          (cancelByDate == null && event.date.isAfter(DateTime.now()));

      return StreamBuilder<User>(
          stream: CloudDatabase.streamUser(user.uid),
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            if (!snapshot.hasData) {
              return Container(
                width: 0.0,
                height: 0.0,
              );
            }
            final User currUser = snapshot.data;

            return StandardButton(
                onPressed: _handleBookingCallback(
                    context: context,
                    currUser: currUser,
                    isBooked: isBookedAndCancellable),
                text: _getBookingButtonCopy(
                    isBookedAndCancellable: isBookedAndCancellable));
          });
    } else {
      return StandardButton(
          onPressed: _handleBookingCallback(context: context, isBooked: false),
          text: _getBookingButtonCopy());
    }
  }

  Function _handleBookingCallback(
      {BuildContext context, User currUser, bool isBooked}) {
    if (!loggedIn) {
      return () {
        LoginDialog(context);
      };
    } else if (hostingEvent && event.date.isAfter(DateTime.now())) {
      return () {
        Navigator.of(context, rootNavigator: false)
            .push<dynamic>(DefaultPageRoute<dynamic>(
          pageRoute: EventCreation(user: user, event: event),
        ));
      };
    } else if (event.capacity > event.guestIds.length &&
        !event.guestIds.contains(user.uid) &&
        DateTime.now().isBefore(event.date)) {
      return () {
        CircularProgressDialog(context, () {
          CloudDatabase.getAndUpdateArrayUserAndEvents(
              userId: user.uid,
              eventId: event.id,
              removeItem: false,
              callback: (bool success) {
                Navigator.pop(context); //pops loading dialog
                Navigator.of(context, rootNavigator: false)
                    .push<dynamic>(DefaultPageRoute<dynamic>(
                  pageRoute: EventConfirmation(
                    event: event,
                    confirmationSuccess: success,
                    cancellation: false,
                    cancelByDate: cancelByDate,
                  ),
                ));
                if (success) {
                  sendEventBookingConfirmation(
                      currUser.email,
                      currUser.displayName,
                      copy.emailToUserSubject,
                      copy.emailToUserBody(event.title,
                          StringHelper.dateFormatterWithTime(event.date)));
                  final User host = Provider.of<User>(context);
                  if (host != null) {
                    sendEventBookingConfirmation(
                        host.email,
                        host.displayName,
                        copy.emailToHostSubject,
                        copy.emailToHostBody(currUser.displayName, event.title,
                            StringHelper.dateFormatterWithTime(event.date)));
                  }
                }
              });
          if (event.capacity == (event.guestIds.length + 1)) {
            // if the capacity has reached capacity after this user books event
            CloudDatabase.updateDocumentValue(
                collection: 'events',
                document: event.id,
                key: db_key.soldOutDateDBKey,
                value: DateTime.now());
          }
        });
      };
    } else if (isBooked) {
      return () {
        CircularProgressDialog(context, () {
          CloudDatabase.getAndUpdateArrayUserAndEvents(
              userId: user.uid,
              eventId: event.id,
              removeItem: true,
              callback: (bool success) {
                Navigator.pop(context); //pops loading dialog
                Navigator.of(context, rootNavigator: false)
                    .push<dynamic>(DefaultPageRoute<dynamic>(
                  pageRoute: EventConfirmation(
                      event: event,
                      confirmationSuccess: success,
                      cancellation: true,
                      cancelByDate: cancelByDate),
                ));
              });
          if (event.capacity == (event.guestIds.length)) {
            // Event was at capacity but not at capacity anymore
            CloudDatabase.updateDocumentValue(
                collection: 'events',
                key: db_key.soldOutDateDBKey,
                document: event.id,
                value: null);
          }
        });
      };
    } else {
      return null;
    }
  }

  String _getBookingButtonCopy({bool isBookedAndCancellable}) {
    if (loggedIn && event.guestIds.contains(user.uid)) {
      if (isBookedAndCancellable) {
        return copy.cancelBooking;
      }
      return copy.attendingEvent;
    } else if (DateTime.now().isAfter(event.date)) {
      return copy.pastEvent;
    } else if (hostingEvent) {
      return copy.hostEvent;
    } else if (event.capacity > event.guestIds.length) {
      return copy.bookEvent;
    } else {
      return copy.noSpaceEvent;
    }
  }
}

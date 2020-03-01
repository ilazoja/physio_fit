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

import '../../../copyDeck.dart' as copy;
import '../../../models/event.dart';
import '../../../models/user.dart';

class EventDetailsItems extends StatelessWidget {
  EventDetailsItems(
      {Key key, @required this.event, @required this.cancelByDate})
      : super(key: key);

  final Event event;
  final DateTime cancelByDate;
  BuildContext context;
  ScaffoldState scaffoldState;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    scaffoldState = Scaffold.of(context);
    final User _hostUser = Provider.of<User>(context);
    final FirebaseUser firebaseUser = Provider.of<FirebaseUser>(context);

    if (event != null && _hostUser != null) {
      final bool isHost =
          firebaseUser != null && firebaseUser.uid == _hostUser.id;
      final String _contactType = _getContactType(event.hostContact);

      final List<Widget> listViewItems = <Widget>[];

      if (!event.eventCancelled) {
        listViewItems.add(Wrap(runSpacing: 4.5, children: <Widget>[
          _getIconAndText(Icons.location_city, event.city, context),
          _getIconAndText(
              Icons.category,
              (event.categories.toString())
                  .replaceAll('[', '')
                  .replaceAll(']', ''),
              context),
          _getIconAndText(Icons.calendar_today,
              DateFormat.yMMMMd('en_US').add_jm().format(event.date), context)
        ]));

        // Event Duration
        if (event.duration != null) {
          listViewItems.add(const Padding(padding: EdgeInsets.all(4.5 / 2)));
          listViewItems
              .add(_getIconAndText(Icons.timer, getDurationFormat(), context));
        }

        listViewItems.add(const Padding(padding: EdgeInsets.all(15)));

        listViewItems.add(isHost &&
                event.guestIds != null &&
                event.guestIds.isNotEmpty
            ? _getRowAndAction(
                Icons.announcement, copy.broadcastText, context, _displayDialog)
            : Container());

        // Host Name / Message your Guests
        listViewItems.add(isHost
            ? Container()
            : GetIconAndHeadingRow(
                headingIcon: Icons.perm_identity,
                headingText: copy.hostText(_hostUser.displayName)));

        // Host Bio
        listViewItems.add(isHost
            ? Container()
            : GetItemTextRow(bodyText: _hostUser.biography));

        // Host Contact
        listViewItems.add(isHost
            ? Container()
            : contactHostRow(context, firebaseUser, _hostUser, _contactType));

        listViewItems.add(_getDivider());

        // Event Description
        listViewItems.add(GetIconAndHeadingRow(
            headingIcon: Icons.description, headingText: copy.descriptionText));
        listViewItems.add(GetItemTextRow(bodyText: event.description));

        // Event Address
        listViewItems.add(GetIconAndHeadingRow(
            headingIcon: Icons.location_on, headingText: copy.locationText));
        listViewItems.add(GetItemTextRow(bodyText: event.address));

        // Event Capacity
        listViewItems.add(GetIconAndHeadingRow(
            headingIcon: Icons.add_circle, headingText: copy.capacityText));
        listViewItems.add(GetItemTextRow(bodyText: event.capacity.toString()));

        // Event Guest List
        if (event.guestIds.isEmpty) {
          listViewItems.add(GetIconAndHeadingRow(
            headingIcon: Icons.people,
            headingText: copy.guestText(event.guestIds.length),
          ));
        } else {
          listViewItems.add(_getRowAndAction(
              Icons.people,
              copy.guestText(event.guestIds.length),
              context,
              guestListCallBack));
        }
        listViewItems.add(const Padding(padding: EdgeInsets.all(8)));

//      //reviews
//      if (event.reviews.isNotEmpty) {
//        listViewItems.add(_getIconAndHeadingRow(
//            Icons.rate_review, copy.reviewsText, context));
//        for (String _review in event.reviews) {
//          listViewItems.add(_getItemTextRow(_review, context));
//        }
//      }

        listViewItems.add(_getDivider());

        // Event Additional Info
        if (event.additionalInfo.isNotEmpty) {
          listViewItems.add(GetIconAndHeadingRow(
              headingIcon: Icons.transfer_within_a_station,
              headingText: copy.requirementsText));
          for (String requirement in event.additionalInfo) {
            listViewItems.add(GetItemTextRow(bodyText: requirement));
          }
        }
        print(cancelByDate);

        // Event Cancellation
        listViewItems.add(GetIconAndHeadingRow(
            headingIcon: Icons.cancel, headingText: copy.cancellationPolicy));
        listViewItems.add(GetItemTextRow(
            bodyText: copy.cancelBy +
                DateFormat.yMMMMd('en_US').add_jm().format(cancelByDate)));

        if (event.cancellationPolicy.isNotEmpty) {
          listViewItems.add(GetItemTextRow(bodyText: event.cancellationPolicy));
        } else {
          listViewItems.add(GetItemTextRow(
            bodyText: copy.noCancellationPolicy,
          ));
        }
      } else {
        listViewItems.add(_getCancelledEvent());
        if (firebaseUser != null && firebaseUser.uid != _hostUser.id) {
          listViewItems.add(GetIconAndHeadingRow(
              headingIcon: Icons.perm_identity,
              headingText: _hostUser.displayName));
          listViewItems.add(Padding(padding: EdgeInsets.all(5)));
          listViewItems.add(
              contactHostRow(context, firebaseUser, _hostUser, _contactType));
        }
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

  String getDurationFormat() {
    final Duration duration = Duration(hours: event.duration.toInt());
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

  void guestListCallBack() {
    Navigator.of(context).push<dynamic>(DefaultPageRoute<dynamic>(
        pageRoute: GuestListProviderWrapper(eventId: event.id)));
  }

  Future<void> _displayDialog() async {
    return showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return AnnouncementDialog(event: event, scaffoldState: scaffoldState);
        });
  }

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

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:physio_tracker_app/screens/eventDetails/widgets/favouriteButton.dart';
import '../../../models/event.dart';

import '../../../widgets/shared/circular_progress.dart';

class EventDetailsHeading extends StatelessWidget {
  const EventDetailsHeading({
    Key key,
    @required this.event,
  }) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    final FirebaseUser _currUser = Provider.of<FirebaseUser>(context);

    if (event != null) {
      final bool _loggedIn = _currUser != null;

      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: AutoSizeText(
                event.title,
                style: Theme.of(context).textTheme.display1,
                maxLines: 2,
                minFontSize: 18,
              ),
            ),
            Container(
                child: FavouriteButton(
                    eventId: event.id,
                    loggedIn: _loggedIn,
                    size: 30,
                    notSelectedIcon: Icons.favorite_border,
                    notSelectedIconColor: Colors.white))
          ]);
    } else {
      return const CircularProgress(isLoading: true);
    }
  }
}

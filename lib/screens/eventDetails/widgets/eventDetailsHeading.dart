import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:physio_tracker_app/screens/eventDetails/widgets/favouriteButton.dart';
import '../../../models/exercise.dart';

import '../../../widgets/shared/circular_progress.dart';

class EventDetailsHeading extends StatelessWidget {
  const EventDetailsHeading({
    Key key,
    @required this.exercise,
  }) : super(key: key);

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final FirebaseUser _currUser = Provider.of<FirebaseUser>(context);

    if (exercise != null) {
      final bool _loggedIn = _currUser != null;

      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: AutoSizeText(
                exercise.name,
                style: Theme.of(context).textTheme.display1,
                maxLines: 2,
                minFontSize: 18,
              ),
            ),
          ]);
    } else {
      return const CircularProgress(isLoading: true);
    }
  }
}

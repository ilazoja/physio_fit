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
import 'package:physio_tracker_app/screens/patientDetails/providerWrapper/patientDetailsProviderWrapper.dart';
import 'package:intl/intl.dart';

class ExerciseBox extends StatelessWidget {
  ExerciseBox({
    @required this.exercise,
    @required this.setSmall,
    this.detailsPage,
  });

  final Exercise exercise;
  final bool setSmall;
  bool detailsPage;

  @override
  Widget build(BuildContext context) {
    detailsPage ??= false;
    DateTime savedDateTime;
    final FirebaseUser _currUser = Provider.of<FirebaseUser>(context);
    final bool _loggedIn = _currUser != null;
    const double favouriteButtonSize = 20.0;

    return Card(
      child: ListTile(
        title: Text(exercise.name),
        subtitle: Text(exercise.repetitions.toString())
      ),
    );
  }
}
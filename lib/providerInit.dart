import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/event.dart';
import 'models/exercise.dart';
import 'routes.dart';
import 'services/cloud_database.dart';

class ProviderInit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: <SingleChildCloneableWidget>[
      StreamProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.onAuthStateChanged),
      // TODO(some1): Below provider should be moved to as wrapper on top fav
      //  and cal
      StreamProvider<List<Exercise>>.value(value: CloudDatabase.streamEvents())
    ], child: Routes());
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/screens/explore/explore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ExploreProviderWrapper extends StatelessWidget {
  const ExploreProviderWrapper({Key key, @required this.textController}) : super(key: key);
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    final FirebaseUser _user = Provider.of<FirebaseUser>(context);
    String uid = "";
    if (_user != null) {
      uid = _user.uid;
    }
    return  StreamProvider<List<Exercise>>.value(value: CloudDatabase.streamExercisesById(uid),
            child: Explore(textController: textController,),);
  }
}


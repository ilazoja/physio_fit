import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/screens/patientDetails/patientDetails.dart';

class PatientDetailsProviderWrapper extends StatelessWidget {

  const PatientDetailsProviderWrapper({Key key, @required this.textController, this.user}) : super(key: key);

  final User user;

  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return  StreamProvider<List<Exercise>>.value(value: CloudDatabase.streamExercisesById(user.id),
      child: PatientDetails(textController: textController),);
  }
}
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/event.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'patientBox.dart';

class GenericPatientGrid extends StatefulWidget {
  const GenericPatientGrid({Key key, @required this.users}) : super(key: key);
  final List<User> users;

  @override
  _GenericPatientGridState createState() => _GenericPatientGridState();
}

class _GenericPatientGridState extends State<GenericPatientGrid> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        _createEventBoxes(context, widget.users)
      ),
    );
  }

  List<Widget> _createEventBoxes(BuildContext context, List<User> users) {
    final List<Widget> eventBoxes = <Widget>[];

    for (User user in users) {
      if (!user.displayName.isEmpty) {
        eventBoxes.add(PatientBox(
          user: user,
          setSmall: false,
        ));
      }
    }

    return eventBoxes;
  }
}

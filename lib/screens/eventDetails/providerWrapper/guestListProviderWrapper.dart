import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:physio_tracker_app/screens/eventDetails/widgets/guestListDetails.dart';

class GuestListProviderWrapper extends StatelessWidget {
  const GuestListProviderWrapper ({
    Key key,
    @required this.eventId,
  }) : super(key: key);

  final String eventId;
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<User>>.value(
      value: CloudDatabase.streamUserByEvent(eventId),
      child: GuestListDetails(),
    );
  }
}

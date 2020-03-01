import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:physio_tracker_app/models/announcement.dart';
import 'package:physio_tracker_app/screens/inbox/widgets/notifications.dart';

class NotificationProviderWrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final FirebaseUser _user = Provider.of<FirebaseUser>(context);
    return StreamProvider<List<Announcement>>.value(
        value: CloudDatabase.getNotificationsByUser(_user.uid),
        child: Notifications());
  }
}

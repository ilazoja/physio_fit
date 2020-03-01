import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:physio_tracker_app/screens/inbox/widgets/userSelectScreen.dart';

class UserSelectProviderWrapper extends StatelessWidget {
  const UserSelectProviderWrapper ({
    Key key,
    @required this.user,
  }) : super(key: key);

  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<User>>.value(
      value: CloudDatabase.streamUsers(),
      child: UserSelect(user, TextEditingController()),
    );
  }
}

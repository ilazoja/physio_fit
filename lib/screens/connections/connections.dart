import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:physio_tracker_app/widgets/login/notLoggedInWidget.dart';
import '../../copyDeck.dart' as copy;
import '../../services/cloud_database.dart';
import '../../widgets/shared/centeredTextPrompt.dart';

class Connections extends StatefulWidget {
  @override
  _ConnectionsState createState() => _ConnectionsState();
}

class _ConnectionsState extends State<Connections> {
  @override
  Widget build(BuildContext context) {
    final FirebaseUser _user = Provider.of<FirebaseUser>(context);
    final bool _logged = _user != null;

    return Scaffold(
        body: SafeArea(
            child: _logged
                ? StreamProvider<User>.value(
                    value: CloudDatabase.streamUser(_user.uid),
                    child: CenteredTextPrompt(copy.workInProgressText))
                : NotLoggedInWidget(textCopy: copy.connectionsNotLoggedIn)));
  }
}

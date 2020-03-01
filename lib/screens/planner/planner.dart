import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:physio_tracker_app/widgets/login/notLoggedInWidget.dart';
import '../../copyDeck.dart' as copy;
import '../../services/cloud_database.dart';
import './widgets/plannerBuilder.dart';

class Planner extends StatefulWidget {
  const Planner({Key key, @required this.textController}) : super(key: key);
  final TextEditingController textController;

  @override
  _PlannerState createState() => _PlannerState();
}

class _PlannerState extends State<Planner> {
  @override
  Widget build(BuildContext context) {
    final FirebaseUser _user = Provider.of<FirebaseUser>(context);
    final bool _logged = _user != null;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: _logged
            ? SafeArea(
                minimum:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: StreamProvider<User>.value(
                    value: CloudDatabase.streamUser(_user.uid),
                    child: PlannerBuilder(widget.textController)))
            : NotLoggedInWidget(textCopy: copy.plannerNotLoggedIn));
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:physio_tracker_app/widgets/shared/appBarPage.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/widgets/login/notLoggedInWidget.dart';
import '../../copyDeck.dart' as copy;
import './providerWrapper/userSelectProviderWrapper.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import '../../services/cloud_database.dart';
import './widgets/inboxStreamBuilder.dart';

class Inbox extends StatelessWidget {
  Inbox({Key key, this.tab}) : super(key: key);

  final int tab;
  BuildContext context;
  FirebaseUser _user;

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<FirebaseUser>(context);
    final bool _logged = _user != null;
    this.context = context;

    final IconButton addAction =
        IconButton(icon: getAddIcon(), onPressed: _newConvo);

    return Scaffold(
        appBar: AppBarPage(
            title: copy.inboxTitle, action: _logged ? addAction : null),
        body: _logged
            ? StreamProvider<User>.value(
                value: CloudDatabase.streamUser(_user.uid),
                child: InboxStreamBuilder(tab: tab))
            : NotLoggedInWidget(textCopy: copy.inboxNotLoggedIn));
  }

  void _newConvo() {
    Navigator.of(context).push<dynamic>(DefaultPageRoute<dynamic>(
        pageRoute: UserSelectProviderWrapper(user: _user)));
  }

  Widget getAddIcon() {
    return Icon(Icons.add, size: 30, color: Theme.of(context).primaryColor);
  }
}

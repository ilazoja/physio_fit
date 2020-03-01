import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/screens/inbox/providerWrapper/chatScreenProviderWrapper.dart';
import 'package:physio_tracker_app/themeData.dart';
import 'package:physio_tracker_app/widgets/shared/appBarPage.dart';
import 'package:physio_tracker_app/widgets/shared/circular_progress.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'package:physio_tracker_app/widgets/shared/userListItem.dart';
import 'package:provider/provider.dart';

import '../../../copyDeck.dart' as copy;
import '../../../models/user.dart';

class GuestListDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<User> _usersAttending = Provider.of<List<User>>(context);
    if (_usersAttending != null) {
      return Scaffold(
        appBar: AppBarPage(title: copy.guestListTitle),
        body: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: getWidgets(context, _usersAttending)),
      );
    } else {
      return Scaffold(body: const CircularProgress(isLoading: true));
    }
  }

  IconButton getActionIconButton(User user, BuildContext context) {
    final FirebaseUser firebaseUser = Provider.of<FirebaseUser>(context);
    return user.id == firebaseUser.uid
        ? null
        : IconButton(
            icon: Icon(Icons.message,
                size: 25, color: Theme.of(context).accentColor),
            onPressed: () {
              /** Move to Chat Screen */
              Navigator.of(context).push<dynamic>(DefaultPageRoute<dynamic>(
                  pageRoute: ChatScreenProviderWrapper(
                id: firebaseUser.uid,
                peerId: user.id,
                peerName: user.displayName,
                peerAvatar: user.profileImage,
              )));
            });
  }

  // TODO(any): create as new widget
  Widget getUserRows(User _user, BuildContext context) {
    return Stack(children: <Widget>[
      Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: UserListItem(_user,
                        action: getActionIconButton(_user, context))),
                Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Divider(color: chatTheme.greyColor2, thickness: 1.0))
              ],
            ),
          )))
    ]);
  }

  List<Widget> getWidgets(BuildContext context, List<User> _usersAttending) {
    final List<Widget> list = <Widget>[];
    for (User _user in _usersAttending) {
      list.add(getUserRows(_user, context));
    }

    return list;
  }
}

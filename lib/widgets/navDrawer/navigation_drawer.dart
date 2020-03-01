import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:physio_tracker_app/screens/settings/settings.dart';
import 'package:physio_tracker_app/services/authentication.dart';
import 'package:physio_tracker_app/widgets/navDrawer/custom_drawer_header.dart';
import 'package:physio_tracker_app/widgets/navDrawer/drawer_button.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/widgets/navDrawer/drawer_tile.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'package:physio_tracker_app/screens/eventCreation/index.dart';
import 'package:physio_tracker_app/screens/workInProgress/index.dart';
import 'package:physio_tracker_app/widgets/login/loginDialog.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<NavigationDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseUser firebaseUser = Provider.of<FirebaseUser>(context);
    final Authentication _auth = Authentication();
    bool isLoggedIn = firebaseUser != null;

    final Divider regDivider = Divider(
      color: Theme.of(context).scaffoldBackgroundColor,
    );

    return Drawer(
      child: ListView(
        children: <Widget>[
          isLoggedIn
              ? StreamBuilder<User>(
                  stream: CloudDatabase.streamUser(firebaseUser.uid),
                  builder:
                      (BuildContext context, AsyncSnapshot<User> snapshot) {
                    if (snapshot.connectionState != ConnectionState.active) {
                      return Container();
                    }
                    final User user = snapshot.data;
                    return CustomDrawerHeader(currentUser: user);
                  })
              : const CustomDrawerHeader(
                  currentUser: null,
                ),
          DrawerButton(
              text: copy.createEventButton,
              icon: Icons.create,
              onPressed: () {
                if (isLoggedIn) {
                  Navigator.pop(context);
                  Navigator.of(context).push<dynamic>(DefaultPageRoute<dynamic>(
                      pageRoute: EventCreation(user: firebaseUser)));
                  return;
                } else {
                  LoginDialog(context);
                }
              }),
          regDivider,
          ExpansionTile(
            title: DrawerTile(
              text: copy.expansionTileText1,
              icon: Icons.people_outline,
            ),
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.only(left: 30),
                  child: ListTile(
                      title: DrawerTile(
                        text: copy.expansionTileSubText1,
                        icon: Icons.attach_money,
                      ),
                      onTap: popAndPushPage(WorkInProgress()))),
              Container(
                padding: const EdgeInsets.only(left: 30),
                child: ListTile(
                    title: DrawerTile(
                      text: copy.expansionTileSubText2,
                      icon: Icons.contacts,
                    ),
                    onTap: popAndPushPage(WorkInProgress())),
              ),
            ],
          ),
          regDivider,
          ExpansionTile(
            title: DrawerTile(
              text: copy.expansionTileText2,
              icon: Icons.explore,
            ),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 30),
                child: ListTile(
                    title: DrawerTile(
                      text: copy.expansionTileSubText3,
                      icon: Icons.nature_people,
                    ),
                    onTap: popAndPushPage(WorkInProgress())),
              ),
              Container(
                padding: const EdgeInsets.only(left: 30),
                child: ListTile(
                    title: DrawerTile(
                      text: copy.expansionTileSubText4,
                      icon: Icons.plus_one,
                    ),
                    onTap: popAndPushPage(WorkInProgress())),
              ),
            ],
          ),
          regDivider,
          ListTile(
              title: DrawerTile(
                text: copy.tileText3,
                icon: Icons.star_border,
              ),
              onTap: popAndPushPage(WorkInProgress())),
          Divider(
            height: 70,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          ListTile(
              title: DrawerTile(
                text: copy.tileText4,
                icon: Icons.settings,
              ),
              onTap: popAndPushPage(Settings())),
          regDivider,
          ListTile(
              title: DrawerTile(
                text: copy.tileText5,
                icon: Icons.info_outline,
              ),
              onTap: popAndPushPage(WorkInProgress())),
          if (isLoggedIn) ...<Widget>[
            regDivider,
            DrawerButton(
                text: copy.signOutText,
                icon: Icons.exit_to_app,
                onPressed: () {
                  Navigator.pop(context);
                  final Future<bool> status = _auth.signOut();
                  status.then((bool signedOut) {
                    isLoggedIn = signedOut;
                  });
                })
          ],
        ],
      ),
    );
  }

  Function popAndPushPage(Widget pageRoute) {
    return (){
    Navigator.of(context).pop();
    Navigator.of(context).push<dynamic>(
          DefaultPageRoute<dynamic>(pageRoute: pageRoute));
    };
  }
}

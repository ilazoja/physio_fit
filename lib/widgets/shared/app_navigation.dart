import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/services/firebase_notification_handler.dart';
import 'package:physio_tracker_app/widgets/navDrawer/navigation_drawer.dart';
import 'package:physio_tracker_app/widgets/shared/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../screens/account/index.dart';
import '../../screens/connections/index.dart';
import '../../screens/explore/exploreProviderWrapper.dart';
import '../../screens/favourites/index.dart';
import '../../screens/planner/index.dart';

class AppNavigation extends StatefulWidget {
  @override
  _AppNavState createState() => _AppNavState();
}

class _AppNavState extends State<AppNavigation> {
  TextEditingController exploreTextController;
  TextEditingController favouriteTextController;
  TextEditingController plannerTextController;

  int _selectedIndex = 0;

  final FirebaseNotifications _firebaseNotifications = FirebaseNotifications();

  @override
  Widget build(BuildContext context) {
    final FirebaseUser _user = Provider.of<FirebaseUser>(context);
    _firebaseNotifications.setUpFirebase(context);
    // WHERE WE LEFT OFF
    // Need to differentiate app navigation by physio vs other users
    // Then make the following screens:
    // Physiotherapist should have a list of patient ids
    // click a patient - assign exercise - how often
    // create exercise document with patient id
    // patient should only see exercises that they were assigned
    //
    // after this - Build basics for all features, can fill in later
    // 1) click exercise and start it
    // 2) Exercise - timer
    // 3) When done, put it as a done exercise
    // 4) Physiotherapist should be able to view it as well
    final ApplicationBar exploreAppBar =
        ApplicationBar(textController: exploreTextController);
    final ApplicationBar favouriteAppBar = ApplicationBar(
        textController: _user == null ? null : favouriteTextController);
    final ApplicationBar plannerAppBar = ApplicationBar(
        textController: _user == null ? null : plannerTextController);
    const ApplicationBar connectionsAppBar =
        ApplicationBar(textController: null);
    const ApplicationBar accountAppBar = ApplicationBar(textController: null);

    const int explorePageIndex = 0;
    const int accountPageIndex = 4;

    final PreferredSize appBar = PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.color,
        elevation: (_selectedIndex == explorePageIndex) ? 0 : null,
        brightness: Brightness.light,
        title: <Widget>[
          exploreAppBar,
          favouriteAppBar,
          plannerAppBar,
          connectionsAppBar,
          accountAppBar,
        ].elementAt(_selectedIndex),
        automaticallyImplyLeading: false,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset : false,
      drawer: NavigationDrawer(),
      appBar:
          _selectedIndex == accountPageIndex ? null : appBar,
      body: <Widget>[
        ExploreProviderWrapper(
          textController: exploreTextController,
        ),
        Favourites(textController: favouriteTextController),
        Planner(
          textController: plannerTextController,
        ),
        Connections(),
        Account(),
      ].elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).appBarTheme.color,
        unselectedItemColor: Theme.of(context).primaryColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              title: Text('Home'), icon: Icon(Icons.explore)),
          BottomNavigationBarItem(
              title: Text('Exercises'), icon: Icon(Icons.accessibility)),
          BottomNavigationBarItem(
              title: Text('Results'), icon: Icon(Icons.show_chart)),
          BottomNavigationBarItem(
              title: Text('Messages'), icon: Icon(Icons.message)),
          BottomNavigationBarItem(
              title: Text('Options'), icon: Icon(Icons.settings))
        ],
        onTap: _onBarItemTap,
        currentIndex: _selectedIndex,
      ),
    );
  }

  @override
  void dispose() {
    exploreTextController.dispose();
    favouriteTextController.dispose();
    plannerTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    exploreTextController = TextEditingController();
    favouriteTextController = TextEditingController();
    plannerTextController = TextEditingController();
  }

  void _onBarItemTap(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:physio_tracker_app/widgets/shared/app_navigation.dart';

class MyHome extends StatefulWidget {
  @override
  MyHomeState createState() => MyHomeState();
}

class MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin {
  SharedPreferences prefs;
  // Check if this is the first time app is opened after installation,
  // and display onboarding if so ...
  Future<void> checkFirstSeen() async {
    prefs = await SharedPreferences.getInstance();
    final bool _seen =
        prefs.getBool('onboarding-personalization-seen') ?? false;
    if (!_seen) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppNavigation();
  }
}

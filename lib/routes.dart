import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import 'home.dart';
import 'screens/onboarding/onboarding.dart';
import 'themeData.dart';

class Routes extends StatelessWidget {
  final Map<String, WidgetBuilder> _routes = <String, WidgetBuilder>{
    '/onboarding': (BuildContext context) => WelcomeScreen(),
    '/home': (BuildContext context) => MyHome()
  };

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'KiQBack',
        debugShowCheckedModeBanner: false,
        home: MyHome(),
        theme: themeData,
        routes: _routes,
      ),
    );
  }
}

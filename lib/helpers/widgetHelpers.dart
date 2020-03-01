import 'package:flutter/material.dart';

class WidgetHelpers {
  static Map<int, Widget> getTabWidgets(String title1, String title2,
      BuildContext context) {
    final Map<int, Widget> tabWidgets = <int, Widget>{
      0: Container(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          title1,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: Theme.of(context).textTheme.display3.fontFamily,
              fontSize: 15),
        ),
      ),
      1: Container(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          title2,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: Theme.of(context).textTheme.display3.fontFamily,
              fontSize: 15),
        ),
      ),
    };
    return tabWidgets;
  }
}

import 'package:flutter/material.dart';
import 'package:physio_tracker_app/themeData.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'package:physio_tracker_app/screens/settings/settings.dart';
import 'genericHorizontalBox.dart';

class SetPreferencesBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GenericHorizontalBox(children: <Widget>[
      SafeArea(
          child: Card(
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
                bottomLeft: Radius.circular(5.0),
                bottomRight: Radius.circular(5.0),
              )),
              child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.of(context).push<dynamic>(
                        DefaultPageRoute<dynamic>(pageRoute: Settings()));
                  },
                  child: Container(
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                        Icon(
                          Icons.settings,
                          color: greyAccent,
                          size: 60,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            'Set your preferences',
                            style: Theme.of(context)
                                .textTheme
                                .body2
                                .copyWith(color: greyAccent),
                          ),
                        )
                      ])))))
    ]);
  }
}

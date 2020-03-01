import 'package:flutter/material.dart';
import 'package:physio_tracker_app/widgets/shared/centeredTextPrompt.dart';
import 'package:physio_tracker_app/widgets/shared/appBarPage.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;

class WorkInProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPage(),
        body: Container(
            child: Stack(children: <Widget>[
      CenteredTextPrompt(copy.workInProgressText)
    ])));
  }
}

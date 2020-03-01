import 'dart:math';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/event.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/screens/explore/widgets/eventBox.dart';
import 'package:physio_tracker_app/screens/explore/widgets/horizontalScroll/horizontalScrollButton.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'allEventsGridPage.dart';
import 'genericHorizontalBox.dart';

class HorizontalScrollingEvents extends StatefulWidget {
  const HorizontalScrollingEvents(
      {Key key, @required this.eventsUsed, @required this.moreEventsPageTitle})
      : super(key: key);

  final List<Exercise> eventsUsed;
  final String moreEventsPageTitle;

  @override
  _HorizontalScrollingEventState createState() =>
      _HorizontalScrollingEventState();
}

class _HorizontalScrollingEventState extends State<HorizontalScrollingEvents> {
  final List<Widget> list = <Widget>[];
  final int numberOfBoxesDisplayed = 6;
  final double eventBoxAspectRatio = 0.6;

  @override
  void initState() {
    super.initState();

    // Initialize with first 6 (numberOfBoxesDisplayed) Events
    if (widget.eventsUsed != null) {
      for (int i = 0;
          i < min(widget.eventsUsed.length, numberOfBoxesDisplayed);
          i++) {
        list.add(
          EventBox(exercise: widget.eventsUsed[i], setSmall: true),
        );
      }

      if (widget.eventsUsed.length > numberOfBoxesDisplayed) {
        list.add(HorizontalScrollButton(
          buttonText: 'See More',
          callback: seeMoreButtonCallBack(),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GenericHorizontalBox(
      children: list
          .map((Widget widget) =>
              AspectRatio(aspectRatio: eventBoxAspectRatio, child: widget))
          .toList(),
    );
  }

  VoidCallback seeMoreButtonCallBack() {
    return () {
      setState(() {
        // Remove see more button from the horizontal scroll
        list.removeLast(); 

        final int listLength = list.length;
        for (int i = 0;
            i <
                min(widget.eventsUsed.length - numberOfBoxesDisplayed,
                    numberOfBoxesDisplayed);
            i++) {
          list.add(
            EventBox(exercise: widget.eventsUsed[i + listLength], setSmall: true),
          );
        }

        if (widget.eventsUsed.length > list.length) {
          list.add(HorizontalScrollButton(
            buttonText: 'See All',
            callback: seeAllButtonCallBack(),
          ));
        }
      });
    };
  }

  VoidCallback seeAllButtonCallBack() {
    return () {
      Navigator.of(context).push<dynamic>(DefaultPageRoute<dynamic>(
          pageRoute: AllEventsGridPage(
        title: widget.moreEventsPageTitle,
        eventsDisplayed: widget.eventsUsed,
      )));
    };
  }
}

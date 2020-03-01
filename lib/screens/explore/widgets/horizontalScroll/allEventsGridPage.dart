import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/event.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/screens/explore/widgets/eventBox.dart';
import 'package:physio_tracker_app/widgets/shared/appBarPage.dart';

class AllEventsGridPage extends StatelessWidget {
  const AllEventsGridPage({
    Key key,
    @required this.title,
    @required this.eventsDisplayed,
  }) : super(key: key);

  final String title;
  final List<Exercise> eventsDisplayed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarPage(
            title: title),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
                padding: EdgeInsets.only(
                  left: 10,
                  top: MediaQuery.of(context).size.height / 60,
                  bottom: 10,
                  right: 10,
                ),
                sliver: SliverGrid.count(
                    childAspectRatio:
                        MediaQuery.of(context).size.width / 1000 * 1.8,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 0,
                    crossAxisCount: 2,
                    children: createEventBoxes(eventsDisplayed)))
          ],
        ));
  }

  List<Widget> createEventBoxes(List<Exercise> allEvents) {
    final List<Widget> eventBoxWidgets = <Widget>[];
    for (Exercise event in allEvents) {
      eventBoxWidgets.add(EventBox(
        exercise: event,
        setSmall: false,
      ));
    }

    return eventBoxWidgets;
  }
}

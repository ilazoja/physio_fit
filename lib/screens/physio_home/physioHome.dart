import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:physio_tracker_app/screens/explore/widgets/exploreFilterSection.dart';
import 'package:physio_tracker_app/screens/explore/widgets/filter/dateFilterButton.dart';
import 'package:physio_tracker_app/screens/explore/widgets/filter/priceRangeFilter.dart';
import 'package:physio_tracker_app/screens/explore/widgets/genericEventGrid.dart';
import 'package:physio_tracker_app/screens/explore/widgets/horizontalScroll/horizontalScrollingEvents.dart';
import 'package:physio_tracker_app/screens/explore/widgets/exercisesStreamBuilder.dart';
import 'package:physio_tracker_app/screens/explore/widgets/horizontalScroll/setPreferencesBox.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;
import 'package:physio_tracker_app/services/location.dart' as location;
import 'package:physio_tracker_app/screens/eventFilter/filter.dart';
import 'package:physio_tracker_app/models/event.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/widgets/shared/subHeading.dart';
import 'package:physio_tracker_app/screens/explore/widgets/moreEventsButton.dart';
import 'package:physio_tracker_app/screens/eventFilter/locationSwitch.dart';

class PhysioHome extends StatefulWidget {
  PhysioHome({Key key, @required this.textController}) : super(key: key);
  final TextEditingController textController;
  List<Exercise> eventsBasedOnPrefs = <Exercise>[];
  List<Exercise> eventsBasedOnLocation;
  List<String> userPrefs = <String>[];
  bool showSubsections = false;
  bool issearching = false;

  static _PhysioHomeState physioHomeState;


  @override
  _PhysioHomeState createState() => generateState();


  _PhysioHomeState generateState() {
    physioHomeState = _PhysioHomeState();
    return physioHomeState;
  }
}

class _PhysioHomeState extends State<PhysioHome> {
  bool showMoreButtonPressed = false;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    widget.textController.addListener(() {
      if (widget.textController.text != '' && widget.showSubsections == true) {
        setState(() {
          widget.showSubsections = false;
          widget.issearching = true;
        });
      } else if (widget.textController.text == '' &&
          widget.showSubsections == false) {
        setState(() {
          widget.showSubsections = true;
          widget.issearching = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool anyFilterSet = Filter.numFilterSet > 0 ||
        DateFilterButton.filterSet ||
        (LocationSwitch.enableLocationFilter &&
            location.locationPermissionSet) ||
        (PriceRangeFilter.values != PriceRangeFilter.defaultValues);

    final ExercisesStreamBuilder allEventsStream = ExercisesStreamBuilder(
      widget.textController,
      showLess: (showMoreButtonPressed == false) &&
          (widget.showSubsections == true) &&
          (anyFilterSet == false),
    );

    final bool showAllEventsButton = (showMoreButtonPressed == false) &&
        (widget.showSubsections == true) &&
        (ExercisesStreamBuilder.numEvents > 4) &&
        (anyFilterSet == false);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(slivers: <Widget>[
          ExploreFilterSection(),
          const SliverPadding(
            padding: EdgeInsets.only(top: 15),
          ),
          if (widget.showSubsections && anyFilterSet == false) ...<Widget>[
            ...getPreferenceWidgets(),
            createSubHeading(copy.secondSubheading),
            GenericEventGrid(events: getPopularEvents()),
          ],
          createSubHeading(!widget.issearching
              ? copy.allEventsSubHeading
              : copy.searchResultSubHeading),
          allEventsStream,
          if (showAllEventsButton) ...<Widget>[
            SliverToBoxAdapter(
                child: MoreEventsButton(
                    callback: () {
                      setState(() {
                        showMoreButtonPressed = true;
                      });
                    },
                    buttonText: 'More Events'))
          ],
        ]));
  }

  List<Widget> getPreferenceWidgets() {
    final List<Widget> prefWidgets = <Widget>[];

    if (widget.eventsBasedOnPrefs.isNotEmpty) {
      prefWidgets.add(createSubHeading(copy.firstSubheading));
      prefWidgets.add(SliverToBoxAdapter(
        child: HorizontalScrollingEvents(
          eventsUsed: widget.eventsBasedOnPrefs,
          moreEventsPageTitle: copy.firstSubheading,
        ),
      ));
    } else if (widget.userPrefs == null || widget.userPrefs.isEmpty) {
      prefWidgets.add(createSubHeading(copy.firstSubheading));
      prefWidgets.add(SetPreferencesBox());
    }

    return prefWidgets;
  }

  Widget createSubHeading(String subHeading) {
    return SliverToBoxAdapter(
        child: SubHeading(
          heading: subHeading,
        ));
  }

  Future<List<Exercise>> getPreferredEvents() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    widget.userPrefs = prefs.getStringList('user-prefered-categories');

    final List<Exercise> allEvents = widget.eventsBasedOnLocation;
    if (allEvents == null) {
      return <Exercise>[];
    }

    return allEvents;
  }

  List<Exercise> getPopularEvents() {
    List<Exercise> allEvents = widget.eventsBasedOnLocation;
    if (allEvents == null) {
      return <Exercise>[];
    }

    return allEvents.sublist(0, min(allEvents.length, 4));
  }

  List<Exercise> getAlmostSoldOutEvents() {
    List<Exercise> allEvents = widget.eventsBasedOnLocation;
    return allEvents.sublist(0, min(allEvents.length, 4));
  }

  List<Exercise> getRecentlySoldOutEvents() {
    List<Exercise> allEvents = CloudDatabase.getCurrentEventsInProximity(includeSoldOut: true, includeMultiDates: false);
    if (allEvents == null) {
      return <Exercise>[];
    }

    return allEvents.sublist(0, min(allEvents.length, 4));
  }
}

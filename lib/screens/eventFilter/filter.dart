import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physio_tracker_app/models/event.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/screens/eventFilter/filterListTile.dart';
import 'package:physio_tracker_app/screens/eventFilter/subTile.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;
import 'package:physio_tracker_app/screens/explore/widgets/exercisesStreamBuilder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:physio_tracker_app/screens/explore/widgets/filter/categoryFilterButton.dart';
import 'package:physio_tracker_app/screens/explore/widgets/filter/dateFilterButton.dart';
import 'package:physio_tracker_app/screens/explore/widgets/filter/priceRangeFilter.dart';
import 'package:physio_tracker_app/screens/explore/explore.dart';
import 'package:physio_tracker_app/screens/eventFilter/locationSwitch.dart';

class Filter extends StatelessWidget {
  factory Filter() {
    return _filter;
  }
  Filter._internal();
  static int numFilterSet = 0;
  static final Filter _filter = Filter._internal();
  static final List<String> enabledFilters = <String>[];
  final List<Widget> tiles = <Widget>[];

  List<Widget> buildTiles() {
    if (tiles.isEmpty) {
      for (final String cat in copy.categories) {
        tiles.add(FilterListTile(tileText: cat));
        tiles.add(Divider(height: 2, color: Colors.grey[100]));
      }
    }
    return tiles;
  }

  static bool _isSameDay(DateTime d1, DateTime d2) {
    //checks if two dates are the same without looking at time
    final DateFormat formatter = DateFormat('yMd');
    return formatter.format(d1) == formatter.format(d2);
  }

  static Future<void> filterByLocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String latString = prefs.getString('lat');
    final String lngString = prefs.getString('long');
    final double lat = double.parse(latString);
    final double lng = double.parse(lngString);
    const double radius = 1000.0;
    return CloudDatabase.filterEventsByLocation(lat, lng, radius);
  }

  static List<Exercise> filterEvents(List<Exercise> allEvents) {
    List<Exercise> filteredEvents = <Exercise>[];
    filteredEvents = allEvents;

    /*
    if (DateFilterButton.filterSet) {
      final List<Event> tmp = filteredEvents.where((Event event) {
        return (event.date.isAfter(DateFilterButton.startDate) ||
            _isSameDay(event.date, DateFilterButton.startDate)) &&
                (event.date.isBefore(DateFilterButton.endDate) ||
                    _isSameDay(event.date, DateFilterButton.endDate));
      }).toList();

      filteredEvents = tmp;
    }

    if (PriceRangeFilter.values != PriceRangeFilter.defaultValues) {
      final List<Event> tmp = filteredEvents.where((Event event) {
        return event.price >= PriceRangeFilter.values.start &&
            event.price <= PriceRangeFilter.values.end;
      }).toList();

      filteredEvents = tmp;
    }
    */
    return filteredEvents;
  }

  void saveFilterSelection() {
    numFilterSet = 0;
    for (Widget tile in tiles) {
      if (tile is FilterListTile) {
        if (tile.clicked) {
          numFilterSet++;
          if (!enabledFilters.contains(tile.tileText)) {
            enabledFilters.add(tile.tileText);
          }
        } else {
          enabledFilters.remove(tile.tileText);
        }
      }
    }

    if (LocationSwitch.enableLocationFilter) numFilterSet++;
  }

  void clearFilterSelections() {
    numFilterSet = 0;
    for (Widget tile in tiles) {
      if (tile is FilterListTile) {
        if (tile.clicked) {
          tile.tileState.resetTile();
        }
      }
    }

    LocationSwitch.enableLocationFilter = false;
  }

  static List<Event> filterEventsByPref(
      List<Event> allEvents, List<String> userPref) {
    final List<Event> filteredEvents = <Event>[];
    if (allEvents != null) {
      for (Event event in allEvents) {
        for (String filter in userPref) {
          if (event.categories.contains(filter)) {
            filteredEvents.add(event);
            break;
          }
        }
      }
    }

    return filteredEvents;
  }

  static List<Event> sortEventsByPopularity(List<Event> allEvents) {
    allEvents.sort((Event eventA, Event eventB) {
      int numDaysTilEventA = eventA.date.difference(DateTime.now()).inDays;
      if (numDaysTilEventA == 0) numDaysTilEventA = 1;
      int numDaysTilEventB = eventB.date.difference(DateTime.now()).inDays;
      if (numDaysTilEventB == 0) numDaysTilEventB = 1;

      final double seatsRemainingPercentA =
          eventA.guestIds.length / eventA.capacity;
      final double seatsRemainingPercentB =
          eventB.guestIds.length / eventB.capacity;

      return (seatsRemainingPercentB / numDaysTilEventB)
          .compareTo(seatsRemainingPercentA / numDaysTilEventA);
    });

    return allEvents;
  }

  static List<Event> filterAlmostSoldOutEvents(List<Event> allEvents) {
    return allEvents.where((Event event) {
      return (event.guestIds.length / event.capacity >= 0.5) &&
          (event.guestIds.length != event.capacity);
    }).toList();
  }

  static List<Event> filterRecentlySoldOutEvents(List<Event> allEvents) {
    final List<Event> recentlySoldOut = allEvents.where((Event event) {
      return event.soldOutDate != null;
    }).toList();

    recentlySoldOut.sort((Event eventA, Event eventB){
      return eventA.soldOutDate.compareTo(eventB.soldOutDate);
    });

    return recentlySoldOut;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        children: <Widget>[
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                FlatButton(
                  splashColor: Theme.of(context).scaffoldBackgroundColor,
                  child: Text(copy.filterDrawerLeftButtonText,
                      style: TextStyle(
                          fontSize: 18, color: Theme.of(context).accentColor)),
                  onPressed: () {
                    clearFilterSelections();
                  },
                ),
                Text(copy.filterDrawerTitle,
                    style: const TextStyle(fontSize: 20)),
                FlatButton(
                  splashColor: Theme.of(context).scaffoldBackgroundColor,
                  child: Text(copy.filterDrawerRightButtonText,
                      style: TextStyle(
                          fontSize: 18, color: Theme.of(context).accentColor)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SubTile(
                  tileHeading: copy.filterDrawerHeading1,
                  trailingWidget: LocationSwitch())),
          Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: ListView(
                children: <Widget>[
                  SubTile(
                      tileHeading: copy.filterDrawerHeading2,
                      trailingWidget: null),
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: buildTiles(),
                      shrinkWrap: true,
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  void showMenu(BuildContext context) {
    showModalBottomSheet<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
              behavior: HitTestBehavior.opaque, onTap: () {}, child: Filter());
        }).then((void val) {
      saveFilterSelection();
      CategoryFilterButton.filterButtonState.setState(() {});
      if (LocationSwitch.enableLocationFilter) {
        Filter.filterByLocation().then((dynamic n) {
          Filter.updateEffectedWidgets();
        });
      } else {
        Filter.updateEffectedWidgets();
      }
    });
  }

  static void updateEffectedWidgets() {
    ExercisesStreamBuilder.streamBuilderState.setState(() {});
    Explore.exploreState.setState(() {});
  }
}

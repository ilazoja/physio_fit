import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:physio_tracker_app/models/event.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/models/completed_exercise.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/screens/favourites/widgets/favouritesEventBox'
    '.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;
import 'package:physio_tracker_app/helpers/searchHelpers.dart';
import 'package:physio_tracker_app/helpers/widgetHelpers.dart';

class FavouritesBuilder extends StatefulWidget {
  const FavouritesBuilder(this._textController);

  final TextEditingController _textController;

  @override
  _FavouritesBuilderState createState() => _FavouritesBuilderState();
}

class _FavouritesBuilderState extends State<FavouritesBuilder> {
  String _searchValue = '';
  bool search = false;
  int _selectedIndexValue;
  List<Widget> pastEvents = <Widget>[];
  List<Widget> upComingEvents = <Widget>[];

  @override
  void initState() {
    _selectedIndexValue = 0;
    widget._textController.addListener(valueSet);
    super.initState();
  }

  void valueSet() {
    setState(() {
      _searchValue = widget._textController.text;
      if (_searchValue.isNotEmpty) {
        search = true;
      } else {
        search = false;
      }
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User _currUserModel = Provider.of<User>(context);
    if (_currUserModel != null) {
      return Container(
        child: search
            ? ListView(
                shrinkWrap: true,
                children: _getSearchedWidgets(context, _currUserModel),
              )
            : Column(
                children: <Widget>[
                  SizedBox(
                      width: double.infinity,
                      child: CupertinoSegmentedControl<int>(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 7),
                        selectedColor: Theme.of(context).accentColor,
                        pressedColor: Theme.of(context).splashColor,
                        borderColor: Theme.of(context).accentColor,
                        children: WidgetHelpers.getTabWidgets(
                            copy.favouritesTabBar[0],
                            copy.favouritesTabBar[1],
                            context),
                        groupValue: _selectedIndexValue,
                        onValueChanged: (int value) {
                          setState(() => _selectedIndexValue = value);
                        },
                      )),
                  const Padding(
                    padding: EdgeInsets.all(2),
                  ),
                  Expanded(
                    child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: _selectedIndexValue == 0
                            ? _getPastAndUpcomingFavourites(
                                context, _currUserModel, false)
                            : _getPastAndUpcomingFavourites(
                                context, _currUserModel, true)),
                  )
                ],
              ),
      );
    } else {
      return Container();
    }
  }

  List<Widget> _getPastAndUpcomingFavourites(
      BuildContext context, User user, bool pastEvents) {
    final List<Widget> eventBoxes = <Widget>[];

    final List<CompletedExercise> _allEvents = Provider.of<List<CompletedExercise>>(context);
    print(_allEvents);
      if (_allEvents != null) {
          for (CompletedExercise _event in _allEvents) {
            eventBoxes.add(FavouritesEventBox(event: _event));
          }
      }
      return eventBoxes;
  }

  List<Widget> _getSearchedWidgets(BuildContext context, User user) {
    final List<Widget> eventBoxes = <Widget>[];

    final List<CompletedExercise> _allEvents = Provider.of<List<CompletedExercise>>(context);
    if (_allEvents != null) {
      for (CompletedExercise _event in _allEvents) {
        eventBoxes.add(FavouritesEventBox(event: _event));
      }
    }
    return SearchHelpers.addSearchResults(eventBoxes, context);
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/screens/explore/widgets/genericEventGrid.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/screens/eventFilter/filter.dart';
import 'package:physio_tracker_app/screens/eventFilter/locationSwitch.dart';

class PatientStreamBuilder extends StatefulWidget {
  PatientStreamBuilder(this._textController, {this.showLess});

  final TextEditingController _textController;
  static _PatientStreamBuilder streamBuilderState;
  static int numEvents = 0;
  List<Exercise> eventsUsed;
  bool showLess;

  @override
  _PatientStreamBuilder createState() => generateState();

  _PatientStreamBuilder generateState() {
    streamBuilderState = _PatientStreamBuilder();
    return streamBuilderState;
  }
}

class _PatientStreamBuilder extends State<PatientStreamBuilder> {
  String _searchValue = '';
  String backgroundImage = 'assets/illustrations/noEventScreen.svg';

  @override
  void initState() {
    super.initState();
    widget._textController.addListener(valueSet);
  }

  void valueSet() {
    setState(() {
      _searchValue = widget._textController.text;
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
    final List<Exercise> filteredEvents = _getFilteredEvents(context);
    if (filteredEvents != null && filteredEvents.isNotEmpty) {
      PatientStreamBuilder.numEvents = filteredEvents.length;
    }
    print(filteredEvents);
    if (filteredEvents.isEmpty) {
      return SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                  child: SvgPicture.asset(
                    backgroundImage,
                    fit: BoxFit.fitWidth,
                  ))
            ],
          ));
    }

    return GenericEventGrid(
      events: !widget.showLess
          ? filteredEvents
          : filteredEvents.sublist(0, min(filteredEvents.length, 4)),
    );
  }

  List<Exercise> _getFilteredEvents(BuildContext context) {
    if (widget.eventsUsed == null) {
      widget.eventsUsed = Provider.of<List<Exercise>>(context);
    }

    List<Exercise> _allEvents = widget.eventsUsed;

    if (_allEvents != null) {
      if (LocationSwitch.enableLocationFilter) {
        _allEvents = CloudDatabase.getCurrentEventsInProximity
          (includeSoldOut: true, includeMultiDates: true);
      }

      final List<Exercise> _filteredEvents = Filter.filterEvents(_allEvents);
      return _filteredEvents;
    }
    return <Exercise>[];
  }

  bool _likeFunction(String dataText, String searchText) {
    return dataText.toLowerCase().contains(searchText.toLowerCase());
  }
}

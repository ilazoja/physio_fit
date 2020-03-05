import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:physio_tracker_app/models/physiotherapist.dart';
import 'package:physio_tracker_app/screens/patientDetails/widgets/genericExerciseGrid.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/screens/eventFilter/filter.dart';
import 'package:physio_tracker_app/screens/eventFilter/locationSwitch.dart';

class PatientDetailStreamBuilder extends StatefulWidget {
  PatientDetailStreamBuilder({this.showLess});

  static _PatientDetailStreamBuilder streamBuilderState;
  static int numEvents = 0;
  List<Exercise> exercises;
  bool showLess;

  @override
  _PatientDetailStreamBuilder createState() => generateState();

  _PatientDetailStreamBuilder generateState() {
    streamBuilderState = _PatientDetailStreamBuilder();
    return streamBuilderState;
  }
}

class _PatientDetailStreamBuilder extends State<PatientDetailStreamBuilder> {
  String _searchValue = '';
  String backgroundImage = 'assets/illustrations/noEventScreen.svg';

  @override
  void initState() {
    super.initState();
  }

  void valueSet() {
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Exercise> filteredExercises = _getFilteredEvents(context);
    if (filteredExercises != null && filteredExercises.isNotEmpty) {
      PatientDetailStreamBuilder.numEvents = filteredExercises.length;
    }
    if (filteredExercises == null) {
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

    return GenericExerciseGrid(
      exercises: !widget.showLess
          ? filteredExercises
          : filteredExercises.sublist(0, min(filteredExercises.length, 4)),
    );
  }


  List<Exercise> _getFilteredEvents(BuildContext context) {
    if (widget.exercises == null) {
      widget.exercises = Provider.of<List<Exercise>>(context);
    }

    List<Exercise> _allExercises = widget.exercises;
    return _allExercises;
  }
}

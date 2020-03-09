import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:physio_tracker_app/screens/explore/widgets/exploreFilterSection.dart';
import 'package:physio_tracker_app/screens/explore/widgets/filter/dateFilterButton.dart';
import 'package:physio_tracker_app/screens/explore/widgets/filter/priceRangeFilter.dart';
import 'package:physio_tracker_app/screens/explore/widgets/genericEventGrid.dart';
import 'package:physio_tracker_app/screens/explore/widgets/horizontalScroll/horizontalScrollingEvents.dart';
import 'package:physio_tracker_app/screens/explore/widgets/exercisesStreamBuilder.dart';
import 'package:physio_tracker_app/screens/patientDetails/widgets/patientDetailStreamBuilder.dart';
import 'package:physio_tracker_app/screens/explore/widgets/horizontalScroll/setPreferencesBox.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;
import 'package:physio_tracker_app/services/location.dart' as location;
import 'package:physio_tracker_app/screens/eventFilter/filter.dart';
import 'package:physio_tracker_app/models/event.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/widgets/shared/subHeading.dart';
import 'package:physio_tracker_app/screens/patientDetails/widgets/addExerciseButton.dart';
import 'package:physio_tracker_app/screens/explore/widgets/moreEventsButton.dart';
import 'package:physio_tracker_app/screens/eventFilter/locationSwitch.dart';
import 'package:physio_tracker_app/models/user.dart';

class PatientDetails extends StatefulWidget {
  PatientDetails({Key key, @required this.textController, @required this.patient}) : super(key: key);
  final TextEditingController textController;
  final User patient;
  bool showSubsections = false;
  bool issearching = false;

  static _PatientDetailsState patientDetailsState;


  @override
  _PatientDetailsState createState() => generateState();


  _PatientDetailsState generateState() {
    patientDetailsState = _PatientDetailsState();
    return patientDetailsState;
  }
}

class _PatientDetailsState extends State<PatientDetails> {
  bool showMoreButtonPressed = false;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final PatientDetailStreamBuilder allPatients = PatientDetailStreamBuilder(
      patient: widget.patient,
      showLess: (showMoreButtonPressed == false) &&
          (widget.showSubsections == true)
    );

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(slivers: <Widget>[
          ExploreFilterSection(),
          const SliverPadding(
            padding: EdgeInsets.only(top: 15),
          ),
          createSubHeading(!widget.issearching
              ? 'Current Exercises'
              : copy.searchResultSubHeading),
          allPatients,
        ]));
  }

  Widget createSubHeading(String subHeading) {
    return SliverToBoxAdapter(
        child: SubHeading(
          heading: subHeading,
        ));
  }



}
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:physio_tracker_app/models/exercise.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:physio_tracker_app/models/physiotherapist.dart';
import 'package:physio_tracker_app/screens/physio_home/widgets/genericPatientGrid.dart';
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
  List<User> patients;
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
    final List<User> filteredPatients = _getFilteredEvents(context);
    if (filteredPatients != null && filteredPatients.isNotEmpty) {
      PatientStreamBuilder.numEvents = filteredPatients.length;
    }
    print(filteredPatients);
    if (filteredPatients == null) {
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



    return GenericPatientGrid(
      users: !widget.showLess
          ? filteredPatients
          : filteredPatients.sublist(0, min(filteredPatients.length, 4)),
    );
  }

  List _buildList(int count) {
    List<Widget> listItems = List();

    for (int i = 0; i < count; i++) {
      listItems.add(new Padding(padding: new EdgeInsets.all(20.0),
          child: new Text(
              'Item ${i.toString()}',
              style: new TextStyle(fontSize: 25.0)
          )
      ));
    }

    return listItems;
  }

  List<User> _getFilteredEvents(BuildContext context) {
    if (widget.patients == null) {
      widget.patients = Provider.of<List<User>>(context);
    }

    List<User> _allPatients = widget.patients;
    return _allPatients;
  }

  bool _likeFunction(String dataText, String searchText) {
    return dataText.toLowerCase().contains(searchText.toLowerCase());
  }
}

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:physio_tracker_app/helpers/errorMessageHelper.dart';
import 'package:physio_tracker_app/screens/account/widgets/forgotPasswordButton.dart';
import 'package:physio_tracker_app/services/authentication.dart';
import 'package:physio_tracker_app/themeData.dart';
import 'package:physio_tracker_app/widgets/shared/KiqbackSnackbar.dart';
import 'package:physio_tracker_app/widgets/shared/kiqbackLogo.dart';
import 'package:physio_tracker_app/widgets/shared/standardAlertDialog.dart';
import 'package:physio_tracker_app/widgets/shared/singleChildScrollViewWithScrollbar.dart';

import 'package:physio_tracker_app/copyDeck.dart' as copy;
import 'package:physio_tracker_app/screens/account/form_mode.dart';
import 'package:physio_tracker_app/screens/account/widgets/loginInput.dart';
import 'package:physio_tracker_app/screens/account/widgets/primaryLoginButton.dart';
import 'package:physio_tracker_app/screens/account/widgets/secondaryLoginButton.dart';
import 'package:physio_tracker_app/services/authentication.dart';
import 'package:physio_tracker_app/screens/patientDetails/widgets/addExerciseButton.dart';
import 'package:day_selector/day_selector.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'date_and_time_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:physio_tracker_app/dbKeys.dart' as db_key;

typedef VoidCallback = void Function(
    bool isVerified, bool isNewUser, String uid);

class AddExerciseWidget extends StatefulWidget {
  const AddExerciseWidget({this.onLogin});

  final VoidCallback onLogin;

  @override
  State<StatefulWidget> createState() => _ExerciseWidgetState();
}

class _ExerciseWidgetState extends State<AddExerciseWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Authentication _auth = Authentication();

  FormMode formMode;
  String _name, _frequency, _type;
  List _myActivities;
  int repetitions, sets;
  DateTime _dob;
  DateTime _dateTime;
  bool _termsChecked = true;
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    final double sizeHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.black,
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: DecoratedBox(
          position: DecorationPosition.background,
          decoration: const BoxDecoration(),
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.001,
                  vertical: sizeHeight > 750 ? 95.0 : 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: getChildren(sizeHeight),
              ),
            ),
          ),
        ));
  }

  List<Widget> getChildren(double sizeHeight) {
    List<Widget> children = [];
    children.add(loginInputs());
    /*
      Description
      Name
      Repetitions
      Sets
      date
      patientId
      type
     */
    print("formdetails");
    print(_type);
    print(_myActivities);
    print(sets);
    print(repetitions);
    Map<String, dynamic> eventListMap = <String, dynamic>{
      db_key.description: '',
      db_key.exerciseName: '',
      db_key.repetitions: '',
      db_key.sets: sets,
      db_key.patientId: db_key.patientId,
      db_key.type: _type
    };
    print(eventListMap);
    children.add(
        AddExerciseButton(
            buttonText: "Add Exercise",
            callback: () {
            }
        ));
    return children;
  }


  @override
  void dispose() {
    super.dispose();
  }

  DateTime getDateTime(String value) {
    if (value == null || value.isEmpty) return null;
    final DateFormat inputFormat = DateFormat('dd/MM/yyyy');
    return inputFormat.parse(value);
  }


  @override
  void initState() {
    super.initState();
    _myActivities = <dynamic>[];
  }

  Widget loginInputs() {
    DateTime selectedDate = DateTime.now();

    const List<dynamic> daysOfTheWeek = <dynamic>[
      {
        "display": "Monday",
        "value": "Monday",
      },
      {
        "display": "Tuesday",
        "value": "Tuesday",
      },
      {
        "display": "Wednesday",
        "value": "Wednesday",
      },
      {
        "display": "Thursday",
        "value": "Thursday",
      },
      {
        "display": "Friday",
        "value": "Friday",
      },
      {
        "display": "Saturday",
        "value": "Saturday",
      },
      {
        "display": "Sunday",
        "value": "Sunday",
      },
    ];

    String amOrPm = selectedTime.hour >= 12 ? "AM" : "PM";
    String hour = selectedTime.hour >= 12 ? (selectedTime.hour - 12).toString() : selectedTime.hour.toString();

    return Column(children: <Widget>[
      Wrap(
          spacing: 4.0, // gap between adjacent chips
          runSpacing: 4.0, // gap between lines
          direction: Axis.horizontal, // main axis (rows or columns)
          children: <Widget> [
            LoginInput(
                callback: (String val, bool validated) => setState(() {
                  _name = val;
                }),
                loginType: LoginInputType.EXERCISENAME
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(28, 0, 0, 0),
              child: MultiSelectFormField(
                titleText: '',
                autovalidate: false,
                validator: (dynamic value) {
                  if (value == null || value.length == 0) {
                    return 'Please select one or more options';
                  }
                },
                textField: 'display',
                dataSource: daysOfTheWeek,
                valueField: 'value',
                okButtonLabel: 'OK',
                cancelButtonLabel: 'CANCEL',
                // required: true,
                hintText: 'SELECT DAYS PER WEEK',
                value: _myActivities,
                onSaved: (dynamic value) {
                  if (value == null) return;
                  setState(() {
                    _myActivities = value;
                  });
                },
              ),
            ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Icon(
                          Icons.access_time,
                          color: Colors.white,
                          size: 24.0,
                          semanticLabel: 'Text to announce in accessibility modes',
                        ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: RaisedButton(
                        onPressed: () => _selectTime(context),
                        child: Text('Select Time'),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 10, 5),
                        child: AutoSizeText(hour + ":" + selectedTime.minute.toString() + " " + amOrPm , style: TextStyle(color: Colors.white, fontSize: 22, )),
                    )
                  ],
                ),
                LoginInput(
                    callback: (String val, bool validated) => setState(() {
                      print(val);
                      sets = int.parse(val);
                    }),
                    loginType: LoginInputType.EXERCISESETS),
                LoginInput(
                    callback: (String val, bool validated) => setState(() {
                      repetitions = int.parse(val);
                    }),
                    loginType: LoginInputType.EXERCISEREPS)
          ]
      ),
    ]);
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime, builder: (BuildContext context, Widget child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: child,
      );});

    if (picked_s != null && picked_s != selectedTime )
      setState(() {
        selectedTime = picked_s;
      });
  }

  void _changeFormButtons(FormMode toForm) {
    formKey.currentState.reset();
    setState(() {
      formMode = toForm;
    });
  }


  bool _validateAndSave() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/models/user.dart';

typedef VoidCallback = void Function(
    bool isVerified, bool isNewUser, String uid);

class AddExerciseWidget extends StatefulWidget {
  const AddExerciseWidget({this.onLogin, this.patient});

  final VoidCallback onLogin;
  final User patient;

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
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  Widget build(BuildContext context) {
    final double sizeHeight = MediaQuery.of(context).size.height;
    final FirebaseUser _currUser = Provider.of<FirebaseUser>(context);
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
                children: getChildren(sizeHeight, _currUser),
              ),
            ),
          ),
        ));
  }

  Future _showNotification(int id, String title, String body) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        playSound: false, importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      id,
      'title',
      body,
      platformChannelSpecifics,
      payload: 'No_Sound',
    );
  }

  List<Widget> getChildren(double sizeHeight, FirebaseUser user) {
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
    Map<String, dynamic> exercise = <String, dynamic>{
      db_key.description: '',
      db_key.exerciseName:  _type,
      db_key.repetitions: repetitions,
      db_key.date: DateTime.now(),
      db_key.sets: sets,
      db_key.patientId: widget.patient.id,
      db_key.type: _type
    };
    print("EXERCISE");
    print(widget.patient.id);
    children.add(
        AddExerciseButton(
            buttonText: "Add Exercise",
            callback: () {
              CloudDatabase.createNewCollectionItem('exercises', exercise);
              _showNotification(0, 'New Exercise', _type);
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
    _name = '';
    _type = '';
    _frequency = '';
    repetitions = 0;
    sets = 0;
    var initializationSettingsAndroid = new AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    showDialog<dynamic>(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
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
            Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child:  TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.white12,
                    filled: true,
                    hintText: "Flexion/Adduction/Squat",
                    hintStyle: loginTheme.hintStyle,
                    errorStyle: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold
                    ),
                    icon: Icon(Icons.donut_large, color: Colors.white),
                    border: InputBorder.none,
                  ),
                  cursorColor: Theme.of(context).cursorColor,
                  style: Theme.of(context)
                      .textTheme
                      .body2
                      .copyWith(color: loginTheme.primaryColor),
                  onChanged: (String val) {
                    setState(() {
                      _type = val;
                    });
                  },
                )
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
                TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.white12,
                    filled: true,
                    hintText: "Sets",
                    hintStyle: loginTheme.hintStyle,
                    errorStyle: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold
                    ),
                    icon: Icon(Icons.sort, color: Colors.white),
                    border: InputBorder.none,
                  ),
                  cursorColor: Theme.of(context).cursorColor,
                  style: Theme.of(context)
                      .textTheme
                      .body2
                      .copyWith(color: loginTheme.primaryColor),
                  onChanged: (String val) {
                    setState(() {
                      sets = int.parse(val);
                    });
                  },
                ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child:  TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.white12,
                    filled: true,
                    hintText: "Repetitions",
                    hintStyle: loginTheme.hintStyle,
                    errorStyle: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold
                    ),
                    icon: Icon(Icons.donut_large, color: Colors.white),
                    border: InputBorder.none,
                  ),
                  cursorColor: Theme.of(context).cursorColor,
                  style: Theme.of(context)
                      .textTheme
                      .body2
                      .copyWith(color: loginTheme.primaryColor),
                  onChanged: (String val) {
                    setState(() {
                      repetitions = int.parse(val);
                    });
                  },
                )
            )
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
        setState(() {
          selectedTime = picked_s;
        });
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
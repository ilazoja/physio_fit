import 'dart:async';

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
  DateTime _dob;

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
                  horizontal: MediaQuery.of(context).size.width * 0.08,
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
    print("GetCHildren");
    List<Widget> children = [];
    children.add(loginInputs());
    children.add(
        AddExerciseButton(buttonText: "Add Exercise"));
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
  }

  Widget loginInputs() {
    return Column(children: <Widget>[
      LoginInput(
        callback: (String val, bool validated) => setState(() {
          _name = val;
        }),
        loginType: LoginInputType.EXERCISENAME
      ),
      LoginInput(
          callback: (String val, bool validated) => setState(() {
            _frequency = val;
          }),
          loginType: LoginInputType.EXERCISEFREQUENCY),
      LoginInput(
          callback: (String val, bool validated) => setState(() {
            _type = val;
          }),
          loginType: LoginInputType.EXERCISESETS),
      LoginInput(
          callback: (String val, bool validated) => setState(() {
            _type = val;
          }),
          loginType: LoginInputType.EXERCISEREPS),
    ]);
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

  Future<void> _validateAndSubmit() async {
    FocusScope.of(context).unfocus();
    if (_validateAndSave()) {
      String userID = '';
      try {

      } catch (e) {
        final PlatformException platformException = e;
        print('error: $e');
        scaffoldKey.currentState.showSnackBar(KiqbackSnackbar().build(
            platformException != null
                ? platformException.message
                : e.toString()));
      }
    }
  }
}
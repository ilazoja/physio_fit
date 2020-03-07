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

import '../../copyDeck.dart' as copy;
import '../../screens/account/form_mode.dart';
import '../../screens/account/widgets/loginInput.dart';
import '../../screens/account/widgets/primaryLoginButton.dart';
import '../../screens/account/widgets/secondaryLoginButton.dart';
import '../../services/authentication.dart';

typedef VoidCallback = void Function(
    bool isVerified, bool isNewUser, String uid);

class LoginWidget extends StatefulWidget {
  const LoginWidget({this.onLogin});

  final VoidCallback onLogin;

  @override
  State<StatefulWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Authentication _auth = Authentication();

  FormMode formMode;
  String _email, _password, _fname, _lname, _phone, _type;
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
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(''),
                  fit: BoxFit.cover)),
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
    List<Widget> children = [];
    children.add(Padding(padding: EdgeInsets.all(sizeHeight * 0.005)));
    switch (formMode) {
      case FormMode.LOGIN:
        {
          children.add(loginInputs());
          children.add(
              PrimaryLoginButton(_validateAndSubmit, copy.loginButtonText));
        }
        break;

      case FormMode.CREATE_ACCOUNT:
        {
          children.add(signUpInputs());
          children.add(
              PrimaryLoginButton(_validateAndSubmit, copy.signUpButtonText));
        }
        break;

      case FormMode.FORGOT_PASSWORD:
        {
          children.add(LoginInput(
            callback: (String val, bool validated) => setState(() {
              _email = val;
            }),
            loginType: LoginInputType.EMAIL,
          ));
          children.add(PrimaryLoginButton(
              _validateAndSubmit, copy.resetPasswordButtonText));
        }
        break;

      case FormMode.SIGNED_IN:
        {}
        break;

      default:
        {}
        break;
    }

    if (formMode != FormMode.FORGOT_PASSWORD) {
      children.add(
        ForgotPasswordButton(
            callback: () => _changeFormButtons(FormMode.FORGOT_PASSWORD)),
      );
    }

    children.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(FontAwesomeIcons.facebook),
          onPressed: () => _facebookSignIn(),
          iconSize: 48.0,
          color: loginTheme.primaryColor,
        ),
        IconButton(
          icon: Icon(FontAwesomeIcons.googlePlus),
          onPressed: () => _googleSignIn(),
          iconSize: 48.0,
          color: loginTheme.primaryColor,
        )
      ],
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

  String getDisplayName() {
    return _fname + ' ' + _lname;
  }

  @override
  void initState() {
    formMode = FormMode.LOGIN;
    super.initState();
  }

  Widget loginInputs() {
    return Column(children: <Widget>[
      LoginInput(
        callback: (String val, bool validated) => setState(() {
          _email = val;
        }),
        loginType: LoginInputType.EMAIL,
      ),
      LoginInput(
          callback: (String val, bool validated) => setState(() {
                _password = val;
              }),
          loginType: LoginInputType.PASSWORD)
    ]);
  }

  Widget signUpInputs() {
    return Expanded(
        child: SingleChildScrollViewWithScrollbar(
      scrollbarColor: Colors.white.withOpacity(0.75),
      scrollbarThickness: 5.0,
      child: Column(
        children: <Widget>[
          loginInputs(),
          LoginInput(
            callback: (String val, bool validated) => setState(() {
              _fname = val;
            }),
            loginType: LoginInputType.FNAME,
          ),
          LoginInput(
              callback: (String val, bool validated) => setState(() {
                    _lname = val;
                  }),
              loginType: LoginInputType.LNAME),
          LoginInput(
            callback: (String val, bool validated) => setState(() {
              _phone = val;
            }),
            loginType: LoginInputType.PHONE,
          ),
          LoginInput(
              callback: (String val, bool validated) => setState(() {
                    _dob = getDateTime(val);
                  }),
              loginType: LoginInputType.DOB),
          LoginInput(
              callback: (String val, bool validated) => setState(() {
                _type = val;
              }),
              loginType: LoginInputType.TYPE)
        ],
      ),
    ));
  }

  void _changeFormButtons(FormMode toForm) {
    formKey.currentState.reset();
    setState(() {
      formMode = toForm;
    });
  }

  /// Third Party Sign in Methods
  Future<void> _facebookSignIn() async {
    _auth.signInWithFacebook().then((Map<String, dynamic> map) {
      widget.onLogin(
          map['user'].isEmailVerified, map['isNewUser'], map['user'].uid);
    }).catchError((Object error) {
      print(error.toString());
      if (error is PlatformException) {
        final PlatformException platformException = error;
        scaffoldKey.currentState
            .showSnackBar(KiqbackSnackbar().build(platformException.message));
      } else {
        scaffoldKey.currentState.showSnackBar(
            KiqbackSnackbar().build(copy.thirdPartySignInError(copy.facebook)));
      }
    });
  }

  Future<void> _googleSignIn() async {
    _auth.signInWithGoogle().then((Map<String, dynamic> map) {
      widget.onLogin(
          map['user'].isEmailVerified, map['isNewUser'], map['user'].uid);
    }).catchError((Object error) {
      print(error.toString());
      PlatformException platformException;

      if (platformException = error) {
        scaffoldKey.currentState
            .showSnackBar(KiqbackSnackbar().build(platformException.message));
      } else {
        scaffoldKey.currentState.showSnackBar(
            KiqbackSnackbar().build(copy.thirdPartySignInError(copy.google)));
      }
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
    print(formMode);
    if (_validateAndSave()) {
      String userID = '';
      try {
        if (formMode == FormMode.LOGIN) {
          _auth.signIn(_email, _password).then((Map<String, dynamic> map) {
            widget.onLogin(
                map['user'].isEmailVerified, map['isNewUser'], map['user'].uid);
          }, onError: (Object error) {
            print(error.toString());
            if (error is PlatformException) {
              final PlatformException pe = error;
              scaffoldKey.currentState.showSnackBar(KiqbackSnackbar()
                  .build(ErrorMessageHelper.getErrorMessage(pe)));
            } else {
              scaffoldKey.currentState.showSnackBar(
                  KiqbackSnackbar().build(copy.emailAndPasswordSignInError));
            }
          });
        } else if (formMode == FormMode.CREATE_ACCOUNT) {
          _auth
              .signUp(_email, _password, getDisplayName(), _phone, _dob, _type)
              .then((Map<String, dynamic> map) {
            userID = map['user'].uid;
            print('Signed up: $userID');
            widget.onLogin(
                map['user'].isEmailVerified, map['isNewUser'], map['user'].uid);
          }).catchError((Object error) {
            if (error is PlatformException) {
              final PlatformException pe = error;
              scaffoldKey.currentState.showSnackBar(KiqbackSnackbar()
                  .build(ErrorMessageHelper.getErrorMessage(pe)));
            } else {
              scaffoldKey.currentState
                  ?.showSnackBar(KiqbackSnackbar().build(copy.signUpError));
            }
          });
        } else {
          _auth.sendPasswordResetLink(_email);
          StandardAlertDialog(context, copy.emailSent, copy.resetPasswordEmail);
        }
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

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:physio_tracker_app/helpers/dateTimeHelper.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:physio_tracker_app/screens/account/providerWrapper/editProfileProviderWrapper.dart';
import 'package:physio_tracker_app/themeData.dart';
import 'package:physio_tracker_app/widgets/login/loginWidget.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'package:physio_tracker_app/widgets/shared/error_message.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/widgets/shared/standardAlertDialog.dart';
import 'package:physio_tracker_app/screens/account/image_type.dart';
import 'package:physio_tracker_app/helpers/imageUploadHelper.dart';
import 'package:physio_tracker_app/dbKeys.dart' as db_key;
import '../../copyDeck.dart' as copy;
import '../../services/authentication.dart';
import '../../services/cloud_database.dart';
import 'editProfile.dart';
import 'form_mode.dart';
import 'widgets/cover.dart';
import 'widgets/profileButton.dart';

class Account extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  FormMode formMode;
  String _errorMessage;
  User user;
  final Authentication _auth = Authentication();
  TextEditingController _navBarTextController;

  @override
  Widget build(BuildContext context) {
    print('building account page');
    return _showBody(context);
  }

  @override
  void dispose() {
    _navBarTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _errorMessage = '';
    print(formMode.toString());
    formMode = FormMode.LOGIN;
    _navBarTextController = TextEditingController();
    super.initState();
  }

  Future<void> profileImageUploadResult(
      String uid, String url, ImageType imageType) async {
    await CloudDatabase.updateDocumentValue(
        collection: 'users',
        document: uid,
        key: db_key.profileImageDBKey,
        value: url);
    setState(() {
      user.profileImage = url;
    });
  }

  Widget _showBody(BuildContext context) {
    final FirebaseUser firebaseUser = Provider.of<FirebaseUser>(context);
    final bool isLoggedIn = firebaseUser != null;
    if (isLoggedIn) {
      return Scaffold(
          body: StreamBuilder<User>(
        stream: CloudDatabase.streamUser(firebaseUser.uid),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          user = snapshot.data;
          return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Cover(
                  isVerified: firebaseUser.isEmailVerified ?? false,
                    screenSize: MediaQuery.of(context).size,
                    coverUploadCallback: () {},
                    profileUploadCallback: () {
                      ImageUploadHelper.profileImageUpload(
                          user.id, context, profileImageUploadResult);
                    },
                    coverImageStr: user.coverImage,
                    profileImageStr: user.profileImage),
                Container(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          (user.displayName == null || user.displayName.isEmpty)
                              ? copy.nameEditingText
                              : user.displayName,
                          style: accountTheme.nameStyle,
                        ),
                        Text(
                          'Toronto, Ontario',
                          //TODO: fetch from location preferences
                          style: TextStyle(
                              fontFamily: mainFont,
                              color: const Color(0xff8C8C8C),
                              fontSize: 14),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ProfileButton(
                                callback: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push<dynamic>(DefaultPageRoute<dynamic>(
                                          pageRoute: EditProfile(user: user)));
                                },
                                buttonText: copy.editProfileText),
                            ProfileButton(
                                callback: _signOutUser,
                                buttonText:
                                    copy.signOutText), // Sign out button
                          ],
                        ),
                        firebaseUser.isEmailVerified ?? false
                            ? Container()
                            : ProfileButton(
                          color: Colors.redAccent,
                                callback: () {
                                  firebaseUser.sendEmailVerification();
                                  StandardAlertDialog(
                                      context,
                                      copy.verificationEmailSentTitle,
                                      copy.verificationEmailSentContext);
                                },
                                buttonText: copy.verifyAccount),
                        const Divider(
                            indent: 50.0,
                            endIndent: 50.0,
                            color: Color(0xff8C8C8C)),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.0)),
                        Container(
                          alignment: const Alignment(-1.0, 0.0),
                          child: Text("Exercise Reminder Time",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          alignment: const Alignment(-1.0, 0.0),
                          child: AutoSizeText(
                            '8:30 PM'
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.0)),
                        Container(
                          alignment: const Alignment(-1.0, 0.0),
                          child: Text(copy.phoneTitle,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          alignment: const Alignment(-1.0, 0.0),
                          child: AutoSizeText(
                            (user.phone == null || user.phone.isEmpty)
                                ? copy.phoneEditingText
                                : user.phone,
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.0)),
                        Container(
                          alignment: const Alignment(-1.0, 0.0),
                          child: Text(copy.dobTitle,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          alignment: const Alignment(-1.0, 0.0),
                          child: AutoSizeText(
                            (user.dob == null)
                                ? copy.dobEnterHint
                                : DateTimeHelper.dateTimeToString(user.dob),
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              alignment: const Alignment(-1.0, 0.0),
                              child: Text(copy.currentBusinessHeadingText,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ),
                            Container(
                              alignment: const Alignment(1.0, 0.0),
                              child: Text(
                                  DateTimeHelper.getTimeLineFrom(
                                      user.currentBusiness['startDate'],
                                      user.currentBusiness['endDate']),
                                  style: accountTheme.timelineStyle),
                            ),
                          ],
                        ),
                        Container(
                          alignment: const Alignment(-1.0, 0.0),
                          child: AutoSizeText(
                            (user.currentBusiness == null ||
                                    user.currentBusiness.isEmpty)
                                ? copy.currentBusinessInputText
                                : user.currentBusiness['name'],
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.0)),
                        Container(
                          alignment: const Alignment(-1.0, 0.0),
                          child: Text(copy.experiencesHeadingText,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          alignment: const Alignment(-1.0, 0.0),
                          child: AutoSizeText(
                            (user.experiences == null ||
                                    user.experiences.isEmpty)
                                ? copy.experiencesInputText
                                : user.experiences,
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.0)),
                        Container(
                          alignment: const Alignment(-1.0, 0.0),
                          child: Text(copy.skillsHeadingText,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          alignment: const Alignment(-1.0, 0.0),
                          child: AutoSizeText(
                            (user.skills == null || user.skills.isEmpty)
                                ? copy.skillsInputText
                                : user.skills,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.0),
                        ),
                        Container(
                          alignment: const Alignment(-1.0, 0.0),
                          child: Text(copy.reviewsHeadingText,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          alignment: const Alignment(-1.0, 0.0),
                          child: AutoSizeText(
                            (user.reviews == null || user.reviews.isEmpty)
                                ? copy.reviewsInputText
                                : user.reviews,
                          ),
                        ),
                      ],
                    )),
                ErrorMessage(_errorMessage),
              ],
            ),
          );
        },
      ));
    } else {
      return LoginWidget(
          onLogin: (bool isVerified, bool isNewUser, String uid) {
        if (isNewUser) {
          Navigator.of(context, rootNavigator: true)
              .push<dynamic>(DefaultPageRoute<dynamic>(
                  pageRoute: StreamProvider<User>.value(
            value: CloudDatabase.streamUser(uid),
            child: EditProfileProviderWrapper(
                isNewUser: isNewUser, isVerified: isVerified),

          )));
        }
      });
    }
  }

  //  Post Log In methods
  Future<void> _signOutUser() async {
    try {
      await _auth.signOut();
      setState(() {
        formMode = FormMode.LOGIN;
      });
    } catch (e) {
      print('error: $e');
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }
}

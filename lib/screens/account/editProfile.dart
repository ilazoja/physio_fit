import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:physio_tracker_app/dbKeys.dart' as db_key;
import 'package:physio_tracker_app/helpers/imageUploadHelper.dart';
import 'package:physio_tracker_app/helpers/stringHelper.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:physio_tracker_app/services/authentication.dart';
import 'package:physio_tracker_app/widgets/shared/appBarPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:physio_tracker_app/widgets/shared/defaultTextField.dart';
import 'package:physio_tracker_app/widgets/shared/standardAlertDialog.dart';
import 'package:physio_tracker_app/widgets/shared/standardButton.dart';
import '../../copyDeck.dart' as copy;
import '../../services/cloud_database.dart';
import '../../widgets/shared/circularProgressDialog.dart';
import 'image_type.dart';
import 'widgets/cover.dart';

class EditProfile extends StatefulWidget {
  EditProfile({@required this.user, this.isNewUser});
  final User user;
  bool isNewUser;

  @override
  State<StatefulWidget> createState() => _EditProfileState(user);
}

class _EditProfileState extends State<EditProfile> {
  _EditProfileState(this._user);
  final User _user;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _nameTextController;
  TextEditingController _biographyTextController;
  TextEditingController _currentBusinessTextController;
  TextEditingController _experiencesTextController;
  TextEditingController _skillsTextController;
  TextEditingController _reviewsTextController;
  TextEditingController _phoneTextController;

  Brightness appBarBrightness;

  final String _collection = 'users';

  String _coverImageURL;
  File _coverImage;

  String _profileImageURL;
  File _profileImage;

  DateTime currentStartDate;
  DateTime currentEndDate;

  bool isVerified;

  void addTextListeners() {
    _nameTextController = TextEditingController(text: _user.displayName);
    _biographyTextController = TextEditingController(text: _user.biography);
    _currentBusinessTextController =
        TextEditingController(text: _user.currentBusiness['name']);
    _experiencesTextController = TextEditingController(text: _user.experiences);
    _skillsTextController = TextEditingController(text: _user.skills);
    _phoneTextController = TextEditingController(text: _user.phone);

    _nameTextController.addListener(() {
      _user.displayName = _nameTextController.text;
    });
    _biographyTextController.addListener(() {
      _user.biography = _biographyTextController.text;
    });
    _currentBusinessTextController.addListener(() {
      _user.currentBusiness['name'] = _currentBusinessTextController.text;
    });
    _experiencesTextController.addListener(() {
      _user.experiences = _experiencesTextController.text;
    });
    _skillsTextController.addListener(() {
      _user.skills = _skillsTextController.text;
    });
    _phoneTextController.addListener(() {
      _user.phone = _phoneTextController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    Authentication().getFirebaseUser().then((FirebaseUser user) {
      setState(() {
        isVerified = user.isEmailVerified;
      });
    });
    // TODO(xenon): Should be able to get isNewUser value from above firebase
    //  user, instead of passing down
    widget.isNewUser ??= false;
    final bool showBackButton = !(widget.isNewUser ??= false);
    addTextListeners();
    return WillPopScope(
      onWillPop: () async => showBackButton,
      child: Scaffold(
          appBar: AppBarPage(
              brightness: appBarBrightness, showBackButton: showBackButton),
          body: Form(
            key: _key,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Cover(
                  screenSize: MediaQuery.of(context).size,
                  coverUploadCallback: () {
                    showCupertinoModalPopup<dynamic>(
                      context: context,
                      builder: (BuildContext context) => CupertinoActionSheet(                                 
                          cancelButton: CupertinoActionSheetAction(            
                            child: Text(copy.cancelStr), 
                            isDefaultAction: true,            
                            onPressed: () {              
                              Navigator.pop(context, 'Cancel');            
                            },          
                          ),
                          actions: <Widget>[
                            CupertinoActionSheetAction( 
                              child: Text(copy.uploadCoverPicture), 
                              onPressed: () { 
                                ImageUploadHelper.coverImageUpload(
                                  _user.id, context, imageUploadResult);
                                  Navigator.pop(context);
                                }
                              ),
                              CupertinoActionSheetAction( 
                              child: Text(copy.removeCoverPicture), 
                              onPressed: () { 
                                  CloudDatabase.updateDocumentValue(
                                    collection: 'users',
                                    document: _user.id,
                                    key: db_key.coverImageDBKey,
                                    value: '',
                                  );
                                  setState(() {
                                    _coverImageURL = '';
                                  });
                                  Navigator.pop(context);
                                }
                              ),
                          ]
                        ),
                    );
                  },
                  profileUploadCallback: () {
                    showCupertinoModalPopup<dynamic>(
                      context: context,
                      builder: (BuildContext context) => CupertinoActionSheet(                                 
                          cancelButton: CupertinoActionSheetAction(            
                            child: Text(copy.cancelStr),            
                            isDefaultAction: true,            
                            onPressed: () {              
                              Navigator.pop(context, 'Cancel');            
                            },          
                          ),
                          actions: <Widget>[
                            CupertinoActionSheetAction( 
                              child: Text(copy.uploadProfilePicture), 
                              onPressed: () { 
                                ImageUploadHelper.profileImageUpload(
                                 _user.id, context, imageUploadResult);
                                  Navigator.pop(context);
                                }
                              ),
                              CupertinoActionSheetAction( 
                              child: Text(copy.removeProfilePicture), 
                              onPressed: () { 
                                  CloudDatabase.updateDocumentValue(
                                    collection: 'users',
                                    document: _user.id,
                                    key: db_key.profileImageDBKey,
                                    value: '',
                                  );
                                  setState(() {
                                    _profileImageURL = '';
                                  });
                                  Navigator.pop(context);
                                }                              
                              ),
                          ]
                        ),
                    );
                  },                  
                  coverImageStr: _coverImageURL,
                  profileImageStr: _profileImageURL,
                  isVerified: isVerified,
                ),
                DefaultTextField(
                    textController: _nameTextController,
                    text: '',
                    hintText: copy.nameEditingText,
                    errorText: copy.nameEmptyError,
                    required: true,
                    callback: (String val, bool validated) => setState(() {
                          _user.displayName = val;
                        })),
                DefaultTextField(
                    textController: _phoneTextController,
                    keyboardType: TextInputType.phone,
                    text: '',
                    hintText: copy.phoneEditingText,
                    errorText: copy.phoneEmptyError,
                    required: true,
                    callback: (String val, bool validated) => setState(() {
                          _user.phone = val;
                        })),
                FlatButton(
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          maxTime: DateTime.now(), onConfirm: (DateTime date) {
                        setState(() {
                          _user.dob = date;
                        });
                      }, currentTime: _user.dob, locale: LocaleType.en);
                    },
                    child: Text(
                      _user.dob == null
                          ? copy.dobEnterHint
                          : StringHelper.dateFormatterNoTime(_user.dob),
                      style: TextStyle(color: Theme.of(context).accentColor),
                    )),
                DefaultTextField(
                  textController: _biographyTextController,
                  text: copy.biographyHeadingText,
                  hintText: copy.biographyEditingText,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true, maxTime: currentEndDate,
                              onConfirm: (DateTime date) {
                            setState(() {
                              currentStartDate = date;
                            });
                          },
                              currentTime: currentStartDate,
                              locale: LocaleType.en);
                        },
                        child: Text(
                          currentStartDate == null
                              ? copy.pickStartDate
                              : StringHelper.dateFormatterNoTime(
                                  currentStartDate),
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        )),
                    FlatButton(
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: currentStartDate,
                              maxTime: DateTime.now(),
                              onConfirm: (DateTime date) {
                            setState(() {
                              currentEndDate = date;
                            });
                          },
                              currentTime: currentEndDate,
                              locale: LocaleType.en);
                        },
                        child: Text(
                          currentEndDate == null
                              ? copy.pickEndDate
                              : StringHelper.dateFormatterNoTime(
                                  currentEndDate),
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        )),
                  ],
                ),
                DefaultTextField(
                  textController: _currentBusinessTextController,
                  hintText: copy.currentBusinessHeadingText,
                ),
                DefaultTextField(
                  textController: _experiencesTextController,
                  hintText: copy.experiencesHeadingText,
                ),
                DefaultTextField(
                  textController: _skillsTextController,
                  hintText: copy.skillsHeadingText,
                ),
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 20.0),
                    child: StandardButton(
                      onPressed: () => saveButtonClicked(context),
                      text: copy.saveProfileText,
                    )),
              ],
            ),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nameTextController.dispose();
    _biographyTextController.dispose();
    _currentBusinessTextController.dispose();
    _experiencesTextController.dispose();
    _skillsTextController.dispose();
    _phoneTextController.dispose();
  }

  @override
  void initState() {
    isVerified = false;
    appBarBrightness = Brightness.light;
    _coverImageURL = _user.coverImage;
    _profileImageURL = _user.profileImage;

    Timestamp startTS = _user.currentBusiness['startDate'];
    currentStartDate = startTS?.toDate();

    Timestamp endTS = _user.currentBusiness['endDate'];
    currentEndDate = endTS?.toDate();
    super.initState();
  }

  void saveButtonClicked(BuildContext context) {
    if (_validateAndSave() && _user.dob != null) {
      print('Valid');
      print('New url:' + _coverImageURL);
      final Map<String, Object> userDetails = <String, Object>{
        '${db_key.idDBKey}': _user.id,
        '${db_key.biographyDBKey}': _biographyTextController.text,
        '${db_key.coverImageDBKey}': _coverImageURL,
        '${db_key.currentBusinessDBKey}': {
          '${db_key.currentBusinessNameDBKey}':
              _currentBusinessTextController.text,
          '${db_key.startDate}': currentStartDate,
          '${db_key.endDate}': currentEndDate,
        },
        '${db_key.displayNameDBKey}': _nameTextController.text,
        '${db_key.emailDBKey}': _user.email,
        '${db_key.phoneDBKey}': _user.phone,
        '${db_key.dobDBKey}': _user.dob,
        '${db_key.eventIdsDBKey}': _user.eventIds,
        '${db_key.experiencesDBKey}': _experiencesTextController.text,
        '${db_key.favEventIdsKey}': _user.favEventIds,
        '${db_key.skillsDBKey}': _skillsTextController.text,
        '${db_key.profileImageDBKey}': _profileImageURL,
      };

      CircularProgressDialog(context, () {
        CloudDatabase.updateDocumentValueWithMap(
            collection: _collection,
            document: userDetails['id'],
            map: userDetails,
            callback: () {
              Navigator.pop(context);
              Navigator.of(context, rootNavigator: true)
                  .pop(<File>[_coverImage, _profileImage]);
            });
      });
    } else {
      StandardAlertDialog(context, 'Missing Fields',
          'Please ensure Name, Phone and DOB are entered');
    }
  }

  void imageUploadResult(String uid, String url, ImageType imageType) {
    setState(() {
      if (imageType == ImageType.COVER) {
        _coverImageURL = url;
      }
      if (imageType == ImageType.PROFILE) {
        _profileImageURL = url;
      }
    });
  }

  bool _validateAndSave() {
    final FormState form = _key.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}

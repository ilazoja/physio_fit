import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/dbKeys.dart' as db_key;
import 'package:physio_tracker_app/helpers/imageUploadHelper.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:physio_tracker_app/screens/account/editProfile.dart';
import 'package:physio_tracker_app/screens/account/image_type.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:physio_tracker_app/widgets/shared/circular_image.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';

class CustomDrawerHeader extends StatefulWidget {
  const CustomDrawerHeader({Key key, @required this.currentUser})
      : super(key: key);

  final User currentUser;

  @override
  _CustomDrawerHeaderState createState() => _CustomDrawerHeaderState();
}

class _CustomDrawerHeaderState extends State<CustomDrawerHeader> {
  String profileImage;
  String userName;

  @override
  Widget build(BuildContext context) {
    if (widget.currentUser != null) {
      profileImage = widget.currentUser.profileImage;
      userName = widget.currentUser.displayName;
    } else {
      profileImage = '';
      userName = '';
    }

    const double _drawerHeight = 150.0;
    const double _nameWidth = 155;
    const double _namePaddingLeft = 20;
    const double _namePaddingRight = 5;

    final TextStyle nameTheme =
        TextStyle(fontSize: 20, color: Theme.of(context).primaryColor);

    return Container(
      alignment: Alignment.centerLeft,
      color: Theme.of(context).scaffoldBackgroundColor,
      height: MediaQuery.of(context).padding.top + _drawerHeight,
      child: Stack(children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    height: 95,
                    width: 105,
                    padding: const EdgeInsets.only(left: 12),
                    child: getProfileImage(context)),
                widget.currentUser == null
                    ? Container()
                    : Container(
                        padding: const EdgeInsets.only(left: 12, top: 5),
                        child: InkWell(
                            splashColor: Colors.transparent,
                            child: AutoSizeText(
                              'Edit',
                              style: Theme.of(context).textTheme.body1.copyWith(
                                  color: Theme.of(context).accentColor),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context, rootNavigator: true)
                                  .push<dynamic>(DefaultPageRoute<dynamic>(
                                      pageRoute: EditProfile(
                                          user: widget.currentUser)));
                            }),
                      )
              ],
            ),
            SizedBox(
                width: _nameWidth,
                child: Container(
                    padding: const EdgeInsets.only(
                        left: _namePaddingLeft, right: _namePaddingRight),
                    child: AutoSizeText(
                      userName,
                      style: nameTheme,
                      maxLines: 3,
                    ))),
          ],
        ),
      ]),
    );
  }

  Widget getProfileImage(BuildContext context) {
    return widget.currentUser == null || profileImage != ''
        ? CircularImage(profileImage)
        : GestureDetector(
            onTap: () {
              ImageUploadHelper.profileImageUpload(
                  widget.currentUser.id, context, profileImageUploadResult);
            },
            child: CircularImage(profileImage, isAddProfileImage: true),
          );
  }

  Future<void> profileImageUploadResult(
      String uid, String url, ImageType imageType) async {
    await CloudDatabase.updateDocumentValue(
        collection: 'users',
        document: uid,
        key: db_key.profileImageDBKey,
        value: url);
    setState(() {
      profileImage = url;
    });
  }
}

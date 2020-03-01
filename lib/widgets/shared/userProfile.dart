import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;
import 'package:physio_tracker_app/models/user.dart';
import 'package:physio_tracker_app/screens/account/widgets/cover.dart';
import 'package:physio_tracker_app/widgets/shared/appBarPage.dart';

class UserProfile extends StatefulWidget {
  const UserProfile(this._user);

  final User _user;

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarPage(title: widget._user.displayName),
        body: Stack(
          children: <Widget>[
            _showBody(context),
          ],
        ));
  }

  Widget _showBody(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Cover(
            screenSize: MediaQuery.of(context).size,
            coverUploadCallback: () {},
            profileUploadCallback: () {},
            coverImageStr: widget._user.coverImage,
            profileImageStr: widget._user.profileImage),
        Container(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.user),
                    const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 16.0)),
                    Text(
                      (widget._user.displayName == null ||
                              widget._user.displayName.isEmpty)
                          ? ''
                          : widget._user.displayName,
                      style: Theme.of(context).textTheme.display4,
                    ),
                  ],
                ),
                Row(children: <Widget>[
                  Icon(FontAwesomeIcons.envelope),
                  const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 16.0)),
                  Text(
                    (widget._user.email == null || widget._user.email.isEmpty)
                        ? ''
                        : widget._user.email,
                    style: Theme.of(context).textTheme.display4,
                  ),
                ]),
                Row(children: <Widget>[
                  Icon(FontAwesomeIcons.addressCard),
                  const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 16.0)),
                  Expanded(
                    child: AutoSizeText(
                      (widget._user.biography == null ||
                              widget._user.biography.isEmpty)
                          ? ''
                          : widget._user.biography,
                      style: Theme.of(context).textTheme.display4,
                    ),
                  ),
                ]),
                const Divider(),
                Row(children: <Widget>[
                  const Icon(FontAwesomeIcons.briefcase),
                  const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 16.0)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(copy.currentBusinessHeadingText,
                          style: Theme.of(context).textTheme.display4),
                      Text(
                        (widget._user.currentBusiness == null ||
                                widget._user.currentBusiness.isEmpty)
                            ? ''
                            : widget._user.currentBusiness,
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ],
                  ),
                ]),
                const Padding(padding: EdgeInsets.symmetric(vertical: 6.0)),
                Row(children: <Widget>[
                  Icon(FontAwesomeIcons.businessTime),
                  const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 16.0)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(copy.experiencesHeadingText,
                          style: Theme.of(context).textTheme.display4),
                      Text(
                        (widget._user.experiences == null ||
                                widget._user.experiences.isEmpty)
                            ? ''
                            : widget._user.experiences,
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ],
                  ),
                ]),
                const Divider(),
                Row(children: <Widget>[
                  Icon(FontAwesomeIcons.clipboard),
                  const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 16.0)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(copy.skillsHeadingText,
                          style: Theme.of(context).textTheme.display4),
                      Text(
                        (widget._user.skills == null ||
                                widget._user.skills.isEmpty)
                            ? ''
                            : widget._user.skills,
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ],
                  ),
                ]),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0),
                ),
                Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Icon(FontAwesomeIcons.thumbsUp),
                  const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 16.0)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(copy.reviewsHeadingText,
                          style: Theme.of(context).textTheme.display4),
                      Text(
                        (widget._user.reviews == null ||
                                widget._user.reviews.isEmpty)
                            ? ''
                            : widget._user.reviews,
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ],
                  )
                ]),
              ],
            )),
      ],
    );
  }
}

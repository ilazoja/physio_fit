import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:physio_tracker_app/screens/account/editProfile.dart';
import 'package:provider/provider.dart';

class EditProfileProviderWrapper extends StatelessWidget {
  const EditProfileProviderWrapper({Key key, this.isNewUser, this.isVerified})
      : super(key: key);

  final bool isNewUser;
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return EditProfile(
        user: user, isNewUser: isNewUser);
  }
}

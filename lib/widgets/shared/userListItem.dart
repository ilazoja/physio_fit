import 'package:flutter/material.dart';
import 'package:physio_tracker_app/widgets/shared/circular_image.dart';
import 'package:physio_tracker_app/models/user.dart';

class UserListItem extends StatelessWidget {
  const UserListItem(this._user, {this.action});

  final User _user;
  final IconButton action;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      CircularImage(_user.profileImage, height: 45, width: 45),
      const Padding(padding: EdgeInsets.all(5)),
      Expanded(
        child: Text(
          _user.displayName,
          style: Theme.of(context).textTheme.display4,
          textAlign: TextAlign.left,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      action != null ? action : Container(),
    ]);
  }
}

import 'package:flutter/material.dart';
import 'package:physio_tracker_app/themeData.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:physio_tracker_app/widgets/login/loginDialog.dart';
import 'package:physio_tracker_app/dbKeys.dart' as db_key;

class FavouriteButton extends StatelessWidget {
  const FavouriteButton({
    Key key,
    @required this.eventId,
    @required this.loggedIn,
    @required this.size,
    @required this.notSelectedIcon,
    @required this.notSelectedIconColor,
  }) : super(key: key);

  final String eventId;
  final bool loggedIn;
  final double size;
  final IconData notSelectedIcon;
  final Color notSelectedIconColor;

  @override
  Widget build(BuildContext context) {
    User _currUserModel;

    if (loggedIn) {
      _currUserModel = Provider.of<User>(context);
    }

    return loggedIn &&
            _currUserModel != null &&
            _currUserModel.favEventIds.contains(eventId)
        ? IconButton(
            icon: Icon(Icons.favorite, color: favouriteColor),
            iconSize: size,
            splashColor: Colors.transparent,
            onPressed: () =>
                favouritePressed(true, _currUserModel, loggedIn, context))
        : IconButton(
            icon: Icon(notSelectedIcon),
            color: notSelectedIconColor,
            splashColor: Colors.transparent,
            iconSize: size,
            onPressed: () =>
                favouritePressed(false, _currUserModel, loggedIn, context));
  }

  Function favouritePressed(bool removeItem, User _currUserModel,
      bool _loggedIn, BuildContext context) {
    if (_loggedIn) {
      CloudDatabase.getAndUpdateList(
          objId: _currUserModel.id,
          tableName: db_key.userTableName,
          item: eventId,
          removeItem: removeItem,
          fieldName: db_key.favEventIdsKey);
    } else {
      LoginDialog(context);
    }
  }
}

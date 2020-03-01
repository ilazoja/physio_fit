import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:physio_tracker_app/themeData.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'package:physio_tracker_app/widgets/shared/userListItem.dart';
import '../providerWrapper/chatScreenProviderWrapper.dart';

class UserRow extends StatelessWidget {
  final User _peer;
  final String _userId;

  UserRow(this._peer, this._userId);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5.0),
      child: GestureDetector(
        onTap: () {
          /** Move to Chat Screen */
          Navigator.of(context)
              .push<dynamic>(DefaultPageRoute<dynamic>(
                  pageRoute: ChatScreenProviderWrapper(
            id: _userId,
            peerId: _peer.id,
            peerName: _peer.displayName,
            peerAvatar: _peer.profileImage,
          )))
              .then((dynamic value) {
            Navigator.pop(context);
          });
        },
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              UserListItem(_peer),
              Divider(
                color: chatTheme.greyColor2,
                thickness: 1.0,
                indent: 45,
                endIndent: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}

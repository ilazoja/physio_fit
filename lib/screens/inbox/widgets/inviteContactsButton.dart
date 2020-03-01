import 'package:flutter/material.dart';
import 'package:physio_tracker_app/screens/inviteContacts/inviteContacts.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:physio_tracker_app/themeData.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;
import 'package:permission_handler/permission_handler.dart';
import 'package:physio_tracker_app/widgets/shared/standardAlertDialog.dart';

class InviteContactsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15.0),
      child: Center(
        child: GestureDetector(
          onTap: () async {
            final PermissionStatus permissionStatus = await _getPermission();
            if (permissionStatus == PermissionStatus.granted) {
              Navigator.of(context)
                  .push<dynamic>(
                  DefaultPageRoute<dynamic>(pageRoute: InviteContacts()))
                  .then((dynamic value) {
                Navigator.pop(context);
              });
            } else {
              StandardAlertDialog(context, copy.contactsPermissionsError, '');
            }
          },
          child: Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.person_add, size: 40, color: Colors.lightBlue),
                    const Padding(padding: EdgeInsets.all(5)),
                    Expanded(
                      child: AutoSizeText(copy.inviteContacts,
                          style: Theme.of(context).textTheme.display4
                              .copyWith(color: Colors.lightBlue),
                          textAlign: TextAlign.left,
                          maxLines: 1),
                    )
                  ],
                ),
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
      ),
    );
  }


  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      final Map<PermissionGroup, PermissionStatus> permisionStatus =
      await PermissionHandler()
          .requestPermissions([PermissionGroup.contacts]);
      return permisionStatus[PermissionGroup.contacts] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }
}

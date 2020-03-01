import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:physio_tracker_app/widgets/shared/appBarPage.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;
import 'package:physio_tracker_app/widgets/shared/circular_progress.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:physio_tracker_app/widgets/shared/standardAlertDialog.dart';

class InviteContacts extends StatefulWidget {
  @override
  _InviteContactsState createState() => _InviteContactsState();
}

class _InviteContactsState extends State<InviteContacts> {
  Iterable<Contact> _contacts;

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  Future<void> getContacts() async {
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPage(title: copy.inviteContacts),
      body: _contacts != null
          ? ListView.builder(
              itemCount: _contacts?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Contact c = _contacts?.elementAt(index);
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                  leading: (c.avatar != null && c.avatar.isNotEmpty)
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(c.avatar),
                        )
                      : CircleAvatar(
                          child: Text(c.initials()),
                          backgroundColor: Theme.of(context).accentColor,
                        ),
                  title: Text(c.displayName ?? ''),
                  trailing: InkWell(
                    onTap: () {
                      if (c.phones != null &&
                          c.phones.toList() != null &&
                          c.phones.toList().isNotEmpty &&
                          c.phones.toList()[0].value != null) {
                        _sendSMS(context, copy.contactsInviteMessage,
                            <String>[c.phones.toList()[0].value]);
                      } else {
                        StandardAlertDialog(context, copy.contactNoNumber, '');
                      }
                    },
                    highlightColor: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Invite',
                          style: Theme.of(context)
                              .textTheme
                              .display3
                              .copyWith(color: Colors.lightBlue)),
                    ),
                  ),
                );
              },
            )
          : const CircularProgress(isLoading: true),
    );
  }

  Future<void> _sendSMS(
      BuildContext context, String message, List<String> recipents) async {
    final String _result =
        await FlutterSms.sendSMS(message: message, recipients: recipents)
            .catchError((dynamic onError) {
      print(onError);
      StandardAlertDialog(context, copy.somethingWentWrong, '');
    });
    print(_result);
  }
}

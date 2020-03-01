import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:physio_tracker_app/models/convo.dart';
import 'package:physio_tracker_app/screens/inbox/widgets/messaging.dart';

class MessagingProviderWrapper extends StatelessWidget {
  const MessagingProviderWrapper({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Convo>>.value(
        value: CloudDatabase.getConversations(user.id),
        child: MessagingDetailedProviderWrapper(user: user));
  }
}

class MessagingDetailedProviderWrapper extends StatelessWidget {
  const MessagingDetailedProviderWrapper({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<User>>.value(
        value: CloudDatabase.getUsersByList(
            getUserIds(Provider.of<List<Convo>>(context))),
        child: Messaging(user));
  }

  List<String> getUserIds(List<Convo> _convos) {
    final List<String> users = <String>[];
    if (_convos != null) {
      for (Convo c in _convos) {
        c.userIds[0] != user.id
            ? users.add(c.userIds[0])
            : users.add(c.userIds[1]);
      }
    }
    return users;
  }
}

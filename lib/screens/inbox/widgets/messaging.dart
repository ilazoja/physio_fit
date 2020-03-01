import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/convo.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:physio_tracker_app/widgets/shared/emptyIllustration.dart';
import 'package:provider/provider.dart';
import '../widgets/convoWidget.dart';

class Messaging extends StatefulWidget {
  final User _user;

  const Messaging(this._user);

  @override
  _MessagingState createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  static const String backgroundImage =
      'assets/illustrations/noMessageScreen.svg';

  @override
  Widget build(BuildContext context) {
    final List<Convo> _convos = Provider.of<List<Convo>>(context);
    final List<User> _users = Provider.of<List<User>>(context);
    return _convos == null || _convos.isEmpty
        ? const EmptyIllustration(image: backgroundImage)
        : ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: getWidgets(context, _convos, _users));
  }

  Map<String, User> getUserMap(List<User> users) {
    final Map<String, User> userMap = Map();
    for (User u in users) {
      userMap[u.id] = u;
    }
    return userMap;
  }

  List<Widget> getWidgets(
      BuildContext context, List<Convo> _convos, List<User> _users) {
    final List<Widget> list = <Widget>[];
    if (_convos != null && _users != null && widget._user != null) {
      final Map<String, User> userMap = getUserMap(_users);
      for (Convo c in _convos) {
        if (c.userIds[0] == widget._user.id) {
          list.add(ConvoListItem(
              user: widget._user,
              peer: userMap[c.userIds[1]],
              lastMessage: c.lastMessage));
        } else {
          list.add(ConvoListItem(
              user: widget._user,
              peer: userMap[c.userIds[0]],
              lastMessage: c.lastMessage));
        }
      }
    }

    return list;
  }

}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:physio_tracker_app/screens/inbox/widgets/userRow.dart';
import 'package:physio_tracker_app/widgets/shared/search_field.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/screens/inbox/widgets/inviteContactsButton.dart';

class UserSelect extends StatefulWidget {
  final FirebaseUser _user;
  final TextEditingController _textEditingController;

  UserSelect(this._user, this._textEditingController);

  @override
  _UserSelectState createState() => _UserSelectState();
}

class _UserSelectState extends State<UserSelect> {
  String _searchValue = '';

  void valueSet() {
    setState(() {
      _searchValue = widget._textEditingController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    widget._textEditingController.addListener(valueSet);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<User> _usersList = Provider.of<List<User>>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              splashColor: Colors.transparent,
              onPressed: () => Navigator.pop(context),
              icon:
                  Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
            ),
            SearchField(widget._textEditingController),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: getWidgets(context, _usersList)),
    );
  }

  bool _likeFunction(String dataText, String searchText) {
    return dataText.toLowerCase().contains(searchText.toLowerCase());
  }

  List<Widget> getWidgets(BuildContext context, List<User> userList) {
    final List<Widget> list = <Widget>[];
    list.add(InviteContactsButton());
    if (userList != null) {
      for (User u in userList) {
        if (u.id != widget._user.uid &&
            _likeFunction(u.displayName, _searchValue)) {
          list.add(UserRow(u, widget._user.uid));
        }
      }
    }
    return list;
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/widgets/login/notLoggedInWidget.dart';
import '../../copyDeck.dart' as copy;
import '../../services/cloud_database.dart';
import './widgets/favouritesBuilder.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key key, @required this.textController}) : super(key: key);
  final TextEditingController textController;

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    final FirebaseUser _user = Provider.of<FirebaseUser>(context);
    final bool _logged = _user != null;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: _logged
            ? SafeArea(
                minimum:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: StreamProvider<User>.value(
                    value: CloudDatabase.streamUser(_user.uid),
                    child: FavouritesBuilder(widget.textController)))
            : NotLoggedInWidget(textCopy: copy.favoritesNotLoggedIn));
  }
}

import 'package:flutter/material.dart';
import 'package:physio_tracker_app/screens/inbox/inbox.dart';
import 'package:physio_tracker_app/widgets/shared/search_field.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
class ApplicationBar extends StatelessWidget {
  const ApplicationBar({Key key, @required this.textController})
      : super(key: key);
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    final bool enableSearch = (textController == null) ? false : true;

    return Container(
        child: Row(
          children: <Widget>[
            Container(
              width: 25,
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                padding: const EdgeInsets.all(0),
                icon: Icon(
                  Icons.menu,
                  color: Theme.of(context).appBarTheme.iconTheme.color,
                  size: 25,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            enableSearch
                ? SearchField(textController)
                : Expanded(
                    child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  )),
            Container(
              width: 25,
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                padding: const EdgeInsets.all(0),
                icon: Icon(
                  Icons.message,
                  color: Theme.of(context).appBarTheme.iconTheme.color,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.of(context).push<dynamic>(
                      DefaultPageRoute<dynamic>(pageRoute: Inbox()));
                },
              ),
            ),
          ],
        ));
  }
}

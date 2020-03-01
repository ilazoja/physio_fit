import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/models/user.dart';
import 'package:physio_tracker_app/screens/inbox/providerWrapper/chatScreenProviderWrapper.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:physio_tracker_app/themeData.dart';
import 'package:intl/intl.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'package:physio_tracker_app/widgets/shared/circular_image.dart';

class ConvoListItem extends StatelessWidget {
  ConvoListItem(
      {Key key,
      @required this.user,
      @required this.peer,
      @required this.lastMessage})
      : super(key: key);

  final User user;
  final User peer;
  Map<dynamic, dynamic> lastMessage;

  dynamic _tapPosition;
  BuildContext context;
  String groupId;
  bool read;

  @override
  Widget build(BuildContext context) {
    if (lastMessage['idFrom'] == user.id) {
      read = true;
    } else {
      read = lastMessage['read'] == null ? true : lastMessage['read'];
    }
    this.context = context;
    groupId = getGroupChatId();

    return Container(
        margin: const EdgeInsets.only(
            left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              buildContent(context),
              Divider(
                color: chatTheme.greyColor3,
                height: 10.0,
                thickness: 1.0,
              )
            ])));
  }

  Widget buildContent(BuildContext context) {
    return GestureDetector(
      onTapDown: _storePosition,
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.of(context).push<dynamic>(DefaultPageRoute<dynamic>(
            pageRoute: ChatScreenProviderWrapper(
                id: user.id,
                peerId: peer.id,
                peerName: peer.displayName,
                peerAvatar: peer.profileImage)));
      },
      // TODO: Uncomment LongPress & ShowDeleteMenu function below to get delete working
//        onLongPress: _showDeleteMenu,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(children: <Widget>[
          Column(
            children: <Widget>[
              CircularImage(peer.profileImage, width: 60, height: 60),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width * 0.67,
                    child: buildConvoDetails(peer.displayName, context)),
              ],
            ),
          ),
        ], crossAxisAlignment: CrossAxisAlignment.start),
      ),
    );
  }

  Widget buildConvoDetails(String title, BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  title,
                  style: chatTheme.convoHeading,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              read
                  ? Container()
                  : Icon(Icons.brightness_1,
                      color: Theme.of(context).accentColor, size: 15)
            ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                child: Text(lastMessage['content'],
                    style: chatTheme.convoBody,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.clip),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                getTime(lastMessage['timestamp']),
                style: read ? chatTheme.convoTime : chatTheme.convoTimeUnread,
                textAlign: TextAlign.right,
              ),
            )
          ],
        )
      ],
    );
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void _showDeleteMenu() {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    showMenu(
            context: context,
            items: <PopupMenuEntry<int>>[DeleteEntry()],
            position: RelativeRect.fromRect(
                _tapPosition &
                    const Size(40, 40), // smaller rect, the touch area
                Offset.zero & overlay.size // Bigger rect, the entire screen
                ))
        .then<void>((int delta) {
      // delta would be null if user taps on outside the popup menu
      // (causing it to close without making selection)
      if (delta == null) return;
      // Delete Convo Here
      CloudDatabase.deleteConversation(groupId);
    });
  }

  String getTime(String timestamp) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    DateFormat format;
    if (dateTime.difference(DateTime.now()).inMilliseconds <= 86400000) {
      format = DateFormat('jm');
    } else {
      format = DateFormat.yMd('en_US');
    }
    return format
        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)));
  }

  String getGroupChatId() {
    if (user.id.hashCode <= peer.id.hashCode) {
      return user.id + '_' + peer.id;
    } else {
      return peer.id + '_' + user.id;
    }
  }
}

class DeleteEntry extends PopupMenuEntry<int> {
  @override
  double height = 100;

  // height doesn't matter, as long as we are not giving
  // initialValue to showMenu().

  @override
  bool represents(int n) => n == 1;

  @override
  DeleteEntryState createState() => DeleteEntryState();
}

class DeleteEntryState extends State<DeleteEntry> {
  void deletePressed() {
    // This is how you close the popup menu and return user selection.
    Navigator.pop<int>(context, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlatButton(
              onPressed: deletePressed,
              color: Colors.redAccent,
              child: Text('Delete')),
        ))
      ],
    );
  }
}

import 'dart:async';

import 'package:physio_tracker_app/widgets/shared/appBarPage.dart';
import 'package:physio_tracker_app/widgets/shared/circular_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:intl/intl.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:physio_tracker_app/themeData.dart';

class Chat extends StatelessWidget {
  final String id;
  final String peerId;
  final String groupId;
  final String peerName;
  final String peerAvatar;
  static String currentPeer;

  const Chat(
      {Key key,
      @required this.id,
      @required this.peerId,
      @required this.groupId,
      @required this.peerName,
      @required this.peerAvatar})
      : super(key: key);

  Widget appBarRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Material(
          child: CircularImage(peerAvatar, height: 35, width: 35, iconSize: 35),
          borderRadius: const BorderRadius.all(
            Radius.circular(18.0),
          ),
          clipBehavior: Clip.hardEdge,
        ),
        Container(
          width: MediaQuery.of(context).size.width - 100,
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Text(
            peerName,
            overflow: TextOverflow.clip,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Chat.currentPeer = peerId;

    return Scaffold(
      appBar: AppBarPage(titleWidget: appBarRow(context)),
      body: ChatScreen(id: id, peerId: peerId, groupId: groupId),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String id;
  final String peerId;
  final String groupId;

  ChatScreen(
      {Key key,
      @required this.id,
      @required this.peerId,
      @required this.groupId})
      : super(key: key);

  @override
  State createState() =>
      ChatScreenState(id: id, peerId: peerId, groupChatId: groupId);
}

class ChatScreenState extends State<ChatScreen> {
  String id;

  String peerId;
  String groupChatId;
  List<DocumentSnapshot> listMessage;
  bool isLoading;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  final FocusNode focusNode = FocusNode();
  ChatScreenState(
      {@required this.id, @required this.peerId, @required this.groupChatId});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              buildListMessage(),
              buildInput(),
            ],
          ),
//          buildLoading()
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  Widget buildInput() {
    return Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(width: 1.0, color: chatTheme.greyColor3)),
            color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
          child: Row(
            children: <Widget>[
              // Edit text
              Flexible(
                child: Container(
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        maxLines: 5,
                        cursorColor: Theme.of(context).accentColor,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 15.0),
                        controller: textEditingController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(color: chatTheme.greyColor),
                        ),
                        focusNode: focusNode,
                      )),
                ),
              ),

              // Button send message
              Material(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => onSendMessage(textEditingController.text),
                    color: Theme.of(context).accentColor,
                  ),
                ),
                color: Colors.white,
              ),
            ],
          ),
        ),
        width: double.infinity,
        height: 100.0);
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (!document['read'] && document['idTo'] == id) {
      CloudDatabase.updateMessageRead(document, groupChatId);
    }

    bool lastMessageSame = isLastMessageSame(index);

    if (document['idFrom'] == id) {
      // Right (my message)
      return Row(
        children: <Widget>[
          // Text
          Container(
            child: Bubble(
              elevation: 0,
              padding: const BubbleEdges.all(10.0),
              nip: lastMessageSame ? BubbleNip.no : BubbleNip.rightTop,
              color: Theme.of(context).accentColor,
              child: Text(document['content'],
                  style: TextStyle(color: Colors.white)),
            ),
            width: 200,
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Bubble(
                    elevation: 0,
                    padding: const BubbleEdges.all(10.0),
                    nip: lastMessageSame ? BubbleNip.no : BubbleNip.leftTop,
                    color: chatTheme.greyColor2,
                    child: Text(document['content'],
                        style: TextStyle(color: Colors.black)),
                  ),
                  width: 200.0,
                  margin: const EdgeInsets.only(left: 10.0),
                )
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      getTime(document['timestamp']),
                      style: TextStyle(
                          color: chatTheme.greyColor,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: const EdgeInsets.only(
                        left: 10.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: const EdgeInsets.only(bottom: 10.0),
      );
    }
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

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).accentColor)))
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('messages')
                  .document(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemBuilder: (BuildContext context, int index) =>
                        buildItem(index, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                } else {
                  return Container();
                }
              },
            ),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).accentColor)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  void handleOnSendMessage(bool success) {
    if (!success) {
      showInSnackBar(copy.messageSendFailed);
    }
  }

  @override
  void initState() {
    super.initState();

    isLoading = false;
  }

  bool isLastMessageSame(int index) {
    if ((listMessage != null && index < listMessage.length - 1) &&
        (listMessage[index]['idFrom'] == listMessage[index + 1]['idFrom'])) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (listMessage.isNotEmpty && listMessage.first['idFrom'] != id) {
      updateLastMessage(listMessage.first);
    }
    Navigator.pop(context);
    Chat.currentPeer = null;
    return Future.value(false);
  }

  void onSendMessage(String content) {
    if (content.trim() != '') {
      textEditingController.clear();
      content = content.trim();
      CloudDatabase.sendMessage(
          groupChatId,
          id,
          peerId,
          content,
          DateTime.now().millisecondsSinceEpoch.toString(),
          handleOnSendMessage);
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void updateLastMessage(DocumentSnapshot doc) {
    final DocumentReference documentReference =
        Firestore.instance.collection('messages').document(groupChatId);

    documentReference
        .setData(<String, dynamic>{
          'lastMessage': <String, dynamic>{
            'idFrom': doc['idFrom'],
            'idTo': doc['idTo'],
            'timestamp': doc['timestamp'],
            'content': doc['content'],
            'read': doc['read']
          },
          'users': <String>[id, peerId]
        })
        .then((dynamic success) {})
        .catchError((dynamic error) {
          print(error);
        });
  }

  void showInSnackBar(String value) {
    final scaff = Scaffold.of(context);
    scaff.showSnackBar(SnackBar(
      content: Text(value),
      duration: Duration(seconds: 2),
      action: SnackBarAction(
        label: 'DISMISS',
        onPressed: scaff.hideCurrentSnackBar,
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:physio_tracker_app/screens/inbox/widgets/chatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreenProviderWrapper extends StatelessWidget {
  const ChatScreenProviderWrapper(
      {Key key,
      @required this.id,
      @required this.peerId,
      @required this.peerName,
      @required this.peerAvatar})
      : super(key: key);

  final String id;
  final String peerId;
  final String peerName;
  final String peerAvatar;

  @override
  Widget build(BuildContext context) {
    final String groupId = getGroupChatId();
    return StreamProvider<List<DocumentSnapshot>>.value(
        child: Chat(
            id: id,
            peerId: peerId,
            peerName: peerName,
            peerAvatar: peerAvatar,
            groupId: groupId));
  }

  String getGroupChatId() {
    if (id.hashCode <= peerId.hashCode) {
      return id + '_' + peerId;
    } else {
      return peerId + '_' + id;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:physio_tracker_app/dbKeys.dart' as db_key;

class Convo {
  Convo({this.id, this.userIds, this.lastMessage});

  factory Convo.fromFireStore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data;

    return Convo(
        id: doc.documentID,
        userIds: data[db_key.userTableName] ?? <dynamic>[],
        lastMessage: data[db_key.lastMessageDBKey] ?? <dynamic>{}
    );
  }

  String id;
  List<dynamic> userIds;
  Map<dynamic, dynamic> lastMessage;
}

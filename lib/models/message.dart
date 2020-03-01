import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;
import 'package:physio_tracker_app/dbKeys.dart' as db_key;

class Message {
  Message({this.id, this.content, this.idFrom, this.idTo, this.timestamp});

  factory Message.fromFireStore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data;

    return Message(
      id: doc.documentID,
      content: data[db_key.messageContentDBKey] ?? copy.error,
      idFrom: data[db_key.messageIdFromDBKey] ?? copy.error,
      idTo: data[db_key.messageIdToDBKey] ?? copy.error,
      timestamp: data[db_key.timestampDBKey] ?? copy.error,
    );
  }

  String id;
  String content;
  String idFrom;
  String idTo;
  DateTime timestamp;
}

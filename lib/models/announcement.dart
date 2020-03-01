import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:physio_tracker_app/dbKeys.dart' as db_key;

class Announcement {
  Announcement({this.id, this.title, this.timestamp, this.message, this.eventId});

  factory Announcement.fromFireStore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data;

    return Announcement(
        id: doc.documentID,
        title: data[db_key.titleDBKey] ?? '',
        timestamp: data[db_key.timestampDBKey] ?? '',
        message: data[db_key.messageDBKey] ?? '',
        eventId: data[db_key.eventIdDBKey] ?? '',
    );
  }

  String id;
  String title;
  String timestamp;
  String message;
  String eventId;
}

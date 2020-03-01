import 'dart:async';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:physio_tracker_app/dbKeys.dart' as db_key;
import 'package:physio_tracker_app/models/announcement.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/convo.dart';
import '../models/event.dart';
import '../models/user.dart';
import '../models/exercise.dart';

typedef ConfirmationCallback = void Function(bool success);
typedef MyCallback = void Function(Map<String, dynamic> val);

class CloudDatabase {
  static final Firestore _db = Firestore.instance;
  static final Geoflutterfire _geo = Geoflutterfire();
  static List<DocumentSnapshot> _exercises =
      <DocumentSnapshot>[];

  void nonStatic() {
    // TODO : added to remove dart anaysis, need to convert this into a
    //  libray to avoid error.
  }

  static void addAnouncementToEvent(
      Event event, Map<String, dynamic> map, Function callback) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      Firestore.instance
          .collection('exercises')
          .document(event.id)
          .collection('announcements')
          .document(map['timestamp'])
          .setData(map);
    }).whenComplete(() {
      notifyGuestList(event.guestIds, event.id, event.title, map);
      callback(true);
    }).catchError((dynamic error) {
      callback(false);
    });
  }

  static void notifyGuestList(List<dynamic> userIds, String eventId,
      String eventName, Map<String, dynamic> notification) {
    WriteBatch batch = Firestore.instance.batch();
    for (String id in userIds) {
      batch.setData(
          Firestore.instance
              .collection('users')
              .document(id)
              .collection('notifications')
              .document(notification['timestamp']),
          <String, dynamic>{
            'eventId': eventId,
            'title': eventName,
            'message': notification['message'],
            'timestamp': notification['timestamp']
          });
    }
    batch.commit();
  }

  static void createNewEventsMultiDate(List<Map<String, dynamic>> mapList) {
    final WriteBatch batch = Firestore.instance.batch();

    for (Map<String, dynamic> map in mapList) {
      batch.setData(Firestore.instance.collection('exercises').document(), map);
    }
    batch.commit();
  }

  static void createNewCollectionItem(
      {String collection, Map<String, dynamic> map}) {
    Firestore.instance.runTransaction((Transaction transaction) {
      Firestore.instance.collection(collection).add(map);
      return;
    });
  }

  static void deleteConversation(String groupId) async {
    await Firestore.instance.runTransaction((Transaction myTransaction) async {
      await myTransaction
          .delete(Firestore.instance.collection('messages').document(groupId));
    });
  }

  static Future<void> getAndUpdateArrayUserAndEvents(
      {String userId,
      String eventId,
      ConfirmationCallback callback,
      bool removeItem}) async {
    List<dynamic> eventIdsList;
    List<dynamic> guestIds;

    final DocumentReference documentReferenceUsers =
        Firestore.instance.document('users/' + userId);
    final DocumentReference documentReferenceEvents =
        Firestore.instance.document('events/' + eventId);
    try {
      Firestore.instance.runTransaction((Transaction transaction) async {
        final DocumentSnapshot usersSnapshot =
            await transaction.get(documentReferenceUsers);
        final DocumentSnapshot eventsSnapshot =
            await transaction.get(documentReferenceEvents);

        if (usersSnapshot.data[db_key.eventIdsDBKey] == null) {
          eventIdsList = <String>[];
        } else {
          eventIdsList =
              List<String>.from(usersSnapshot.data[db_key.eventIdsDBKey]);
        }

        if (removeItem) {
          eventIdsList.remove(eventId);
        } else if (!eventIdsList.contains(eventId)) {
          eventIdsList.add(eventId);
        }

        if (eventsSnapshot.data[db_key.guestIdsDBKey] == null) {
          guestIds = <String>[];
        } else {
          guestIds =
              List<String>.from(eventsSnapshot.data[db_key.guestIdsDBKey]);
        }

        if (removeItem) {
          guestIds.remove(userId);
        } else if (!guestIds.contains(userId)) {
          guestIds.add(userId);
        }

        await transaction.update(documentReferenceUsers,
            <String, List<dynamic>>{db_key.eventIdsDBKey: eventIdsList});

        await transaction.update(documentReferenceEvents,
            <String, dynamic>{db_key.guestIdsDBKey: guestIds});
      }).whenComplete(() {
        //Can change this to use .where, but seems uneeded unless guestlist
        // size going to be very very large
        streamEvent(eventId).listen((dynamic data) {
          bool success = false;
          if (!removeItem && data.guestIds.contains(userId) ||
              removeItem && !data.guestIds.contains(userId)) {
            success = true;
          }
          callback(success);
        });
      });
    } catch (e) {
      print(e);
      callback(false);
    }
  }

  static void getAndUpdateList(
      {String objId,
      String tableName,
      String fieldName,
      String item,
      bool removeItem}) {
    final DocumentReference documentReference =
        Firestore.instance.document(tableName + '/' + objId);

    try {
      Firestore.instance.runTransaction((Transaction transaction) async {
        List<dynamic> dataList;
        final DocumentSnapshot snapshot =
            await transaction.get(documentReference);

        if (snapshot.data[fieldName] == null) {
          dataList = <String>[];
        } else {
          dataList = List<String>.from(snapshot.data[fieldName]);
        }

        if (removeItem) {
          // TODO(someone): change to remove all 'items' if button spam cause
          // issues
          dataList.remove(item);
        } else if (!dataList.contains(item)) {
          //Prevents buttons spam
          dataList.add(item);
        }

        await transaction.update(
            documentReference, <String, List<dynamic>>{fieldName: dataList});
      });
    } catch (e) {
      print(e);
    }
  }

  static Stream<List<Convo>> getConversations(String userId) {
    return _db
        .collection('messages')
        .orderBy('lastMessage.timestamp', descending: true)
        .where(db_key.userTableName, arrayContains: userId)
        .snapshots()
        .map((QuerySnapshot list) => list.documents
            .map((DocumentSnapshot doc) => Convo.fromFireStore(doc))
            .toList());
  }

  static Stream<List<Announcement>> getNotificationsByUser(String userId) {
    return _db
        .collection('users')
        .document(userId)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((QuerySnapshot list) => list.documents
            .map((DocumentSnapshot doc) => Announcement.fromFireStore(doc))
            .toList());
  }

  static Stream<List<Announcement>> getNotificationsByEvent(String eventId) {
    return _db
        .collection('exercises')
        .document(eventId)
        .collection('announcements')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((QuerySnapshot list) => list.documents
            .map((DocumentSnapshot doc) => Announcement.fromFireStore(doc))
            .toList());
  }

  static Stream<List<User>> getUsersByList(List<String> userIds) {
    final List<Stream<User>> streams = List();
    for (String id in userIds) {
      streams.add(_db
          .collection('users')
          .document(id)
          .snapshots()
          .map((DocumentSnapshot snap) => User.fromMap(snap.data)));
    }
    return StreamZip<User>(streams).asBroadcastStream();
  }

  static void updateMessageRead(DocumentSnapshot doc, String groupChatId) {
    final DocumentReference documentReference = Firestore.instance
        .collection('messages')
        .document(groupChatId)
        .collection(groupChatId)
        .document(doc.documentID);

    documentReference.setData(<String, dynamic>{'read': true}, merge: true);
  }

  static void sendMessage(String groupChatId, String id, String peerId,
      String content, String timestamp, Function callback) {
    final DocumentReference convoDoc =
        Firestore.instance.collection('messages').document(groupChatId);

    convoDoc.setData(<String, dynamic>{
      'lastMessage': <String, dynamic>{
        'idFrom': id,
        'idTo': peerId,
        'timestamp': timestamp,
        'content': content,
        'read': false
      },
      'users': <String>[id, peerId]
    }).then((dynamic success) {
      final DocumentReference messageDoc = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(timestamp);

      Firestore.instance.runTransaction((Transaction transaction) async {
        await transaction.set(
          messageDoc,
          <String, dynamic>{
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'read': false
          },
        );
      }).then((dynamic success) {
        callback(true);
      }).catchError((dynamic error) {
        print(error);
        callback(false);
      });
    }).catchError((dynamic error) {
      print(error);
      callback(false);
    });
  }

  static Stream<Exercise> streamEvent(String eventId) {
    return _db
        .collection('exercises')
        .document(eventId)
        .snapshots()
        .map((DocumentSnapshot snap) => Exercise.fromFireStore(snap));
  }

  static Stream<List<Exercise>> streamEventsFromMultiDateKey(String multiDateKey) {
    print(_db
        .collection('exercises')
        .snapshots());
    return _db
        .collection('exercises')
        .snapshots()
        .map((QuerySnapshot list) => list.documents
            .map((DocumentSnapshot doc) => Exercise.fromFireStore(doc))
            .toList());
  }

  static Stream<List<Exercise>> streamEvents() {
    final CollectionReference ref = _db.collection('exercises');
    // print(ref.snapshots().map((QuerySnapshot list) => list.documents.map((DocumentSnapshot doc) => doc)).toList());
    return ref.snapshots().map(
            (QuerySnapshot list) => list.documents
            .map((DocumentSnapshot doc) => Exercise.fromFireStore(doc))
            .toList());
  }

  static Stream<List<Event>> streamUpcommingEvents() {
    // Upcmomming events ordered by date
    return _db
        .collection('exercises')
        .orderBy('date')
        .where('date', isGreaterThanOrEqualTo: DateTime.now())
        .where('eventCancelled', isEqualTo: false)
        .snapshots()
        .map((QuerySnapshot list) {
      final List<DocumentSnapshot> indexRemoval = <DocumentSnapshot>[];
      for (DocumentSnapshot documentSnapshot in list.documents) {
        if (documentSnapshot.data[db_key.dateDBKey] == null ||
            documentSnapshot.data[db_key.dateDBKey]
                .toDate()
                .isBefore(DateTime.now()) ||
            (documentSnapshot.data[db_key.eventCancelledDBKey] != null &&
                documentSnapshot.data[db_key.eventCancelledDBKey] == true)) {
          indexRemoval.add(documentSnapshot);
        }
      }

      list.documents.removeWhere((e) => indexRemoval.contains(e));
      return list.documents.map((DocumentSnapshot snap) {
        return Event.fromFireStore(snap);
      }).toList();
    });
  }

  static Stream<User> streamUser(String uid) {
    return _db
        .collection('users')
        .document(uid)
        .snapshots()
        .map((DocumentSnapshot snap) => User.fromMap(snap.data));
  }

  static Stream<List<User>> streamUserByEvent(String eventId) {
    return _db
        .collection('users')
        .where(db_key.eventIdsDBKey, arrayContains: eventId)
        .snapshots()
        .map((QuerySnapshot list) => list.documents
            .map((DocumentSnapshot doc) => User.fromMap(doc.data))
            .toList());
  }

  static Stream<User> streamUserById(String id) {
    return _db
        .collection('users')
        .document(id)
        .snapshots()
        .map((DocumentSnapshot snap) => User.fromMap(snap.data));
  }

  static Stream<List<User>> streamUsers() {
    return _db
        .collection('users')
        .snapshots()
        .map((QuerySnapshot list) => list.documents
            .map((DocumentSnapshot snap) => User.fromMap(snap.data))
            .toList())
        .handleError((dynamic e) {
      print(e);
    });
  }

  ///Sets new data in the database
  static Future<void> updateDocumentValue(
      {String collection, String document, String key, dynamic value}) async {
    try {
      // TODO(shiv): Shouldn't need a transaction here
      Firestore.instance.runTransaction((Transaction transaction) async {
        Firestore.instance
            .collection(collection)
            .document(document)
            .setData(<String, dynamic>{'$key': value}, merge: true);
      });
    } catch (e) {
      print(e);
    }
  }

  ///Only sets the data if not already set
  static Future<void> syncDocumentValueWithMap(
      {String collection,
      String document,
      Map<String, dynamic> map,
      Function callback}) async {
    Firestore.instance.runTransaction((Transaction transaction) {
      Firestore.instance
          .collection(collection)
          .document(document)
          .snapshots()
          .listen((DocumentSnapshot snapshot) {
        if (!snapshot.exists) {
          updateDocumentValueWithMap(
              collection: collection,
              document: document,
              map: map,
              callback: () => print('Updated User'));
        }
        return;
      });
      return;
    }).whenComplete(() {
      callback();
    });
  }

  static Future<void> updateDocumentValueWithMap(
      {String collection,
      String document,
      Map<String, dynamic> map,
      Function callback}) async {
    try {
      // TODO(shiv): Shouldn't need a transaction here
      Firestore.instance.runTransaction((Transaction transaction) async {
        await Firestore.instance
            .collection(collection)
            .document(document)
            .setData(map, merge: true);
      }).whenComplete(() {
        callback();
        return;
      });
      return;
    } catch (e) {
      // TODO(shiv): Return error so we can display an error dialog
      print(e);
      return;
    }
  }

  static Future<void> updateFCMToken(
      {String collection, String document, String key}) async {
    String fcmToken;
    await SharedPreferences.getInstance().then((SharedPreferences prefs) {
      fcmToken = prefs.getString('kiqback_fcm_token');
      print('SHARED PREF: ' + fcmToken);

      final DocumentReference documentReference =
          Firestore.instance.collection(collection).document(document);

      documentReference.setData(<String, String>{key: fcmToken},
          merge: true).whenComplete(() {
        print('Updating FCM Token: Success!');
        print(collection + '/' + document + '/' + key + '/' + fcmToken);
      }).catchError((dynamic e) {
        print(e);
      });
    });
  }

  static String getFCMToken(String uid) {
    DocumentReference documentReference =
        Firestore.instance.document('users/$uid');
    if (documentReference == null) {
      documentReference = Firestore.instance.document('phsyiotherapists/$uid');
    }
    documentReference.get().then<dynamic>((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.data.containsKey(db_key.fcmTokenDBKey)) {
        return documentSnapshot.data[db_key.fcmTokenDBKey];
      } else {
        return null;
      }
    }).catchError((dynamic e) {
      print(e);
    });
  }

  static Future<void> filterEventsByLocation(
      double lat, double lng, double radius) async {
    // Return all ids of all Event documents that are near user's current location (1k km radius)

    final GeoFirePoint center = _geo.point(latitude: lat, longitude: lng);
    final Firestore db = Firestore.instance;
    final CollectionReference ref = db.collection('exercises');

    final List<DocumentSnapshot> listDocuments = await _geo
        .collection(collectionRef: ref)
        .within(
            center: center,
            radius: radius,
            field: 'property.location',
            strictMode: true)
        .first;

    _exercises = listDocuments;

    return listDocuments;
  }

  static List<Exercise> getCurrentEventsInProximity(
      {bool includeSoldOut, bool includeMultiDates}) {
    final List<String> multiEventShown = <String>[];
    final List<DocumentSnapshot> filteredEvents = [];

    _exercises.sort((a, b) {
      return a.data[db_key.dateDBKey].compareTo(b.data[db_key.dateDBKey]);
    });

    for (DocumentSnapshot documentSnapshot in _exercises) {
      //if date is null remove
      filteredEvents.add(documentSnapshot);
    }

    final List<Exercise> currentExercises =
        filteredEvents.map((DocumentSnapshot snap) {
      return Exercise.fromFireStore(snap);
    }).toList();

    return currentExercises;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../copyDeck.dart' as copy;
import '../dbKeys.dart' as db_key;

class Event {
  Event(
      {this.id,
      this.imageSrc,
      this.multiImageSrc,
      this.title,
      this.address,
      this.price,
      this.date,
      this.duration,
      this.daysCancelBy,
      this.guestIds,
      this.capacity,
      this.hostId,
      this.description,
      this.hostContact,
      this.categories,
      this.city,
      this.reviews,
      this.cancellationPolicy,
      this.additionalInfo,
      this.geoPoint,
      this.eventCancelled,
      this.userRelation,
      this.multiDateKey,
      this.soldOutDate});

  factory Event.fromFireStore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data;

    return Event(
        id: doc.documentID,
        imageSrc: data[db_key.imageSrcDBKey] ?? copy.imageSrcError,
        multiImageSrc: data[db_key.multiImageSrcDBKey] ?? <dynamic>[],
        title: data[db_key.titleDBKey] ?? copy.error,
        price: data[db_key.priceDBKey] ?? 0.00,
        address: data[db_key.propertyDBKey][db_key.addressDBKey] ?? copy.error,
        date: data[db_key.dateDBKey].toDate(),
        duration: data[db_key.durationDBKey] ?? 0,
        daysCancelBy: data[db_key.daysCancelByDBKey] ?? 0,
        guestIds: data[db_key.guestIdsDBKey] ?? <dynamic>[],
        capacity: data[db_key.capacityDBKey] ?? 0,
        hostId: data[db_key.hostIdDBKey] ?? copy.error,
        description: data[db_key.descriptionDBKey] ?? copy.error,
        hostContact: data[db_key.hostContactDBKey] ?? copy.error,
        categories: data[db_key.categoriesDBKey] ?? <dynamic>[],
        city: data[db_key.propertyDBKey][db_key.cityDBKey] ?? copy.error,
        reviews: data[db_key.reviewDBKey] ?? <dynamic>[],
        cancellationPolicy: data[db_key.cancellationPolicyDBKey] ?? '',
        additionalInfo: data[db_key.additionalInfoDBKey] ?? <dynamic>[],
        geoPoint: data[db_key.propertyDBKey][db_key.locationDBKey]
            [db_key.geoPointDBKey],
        eventCancelled: data[db_key.eventCancelledDBKey] ?? false,
        multiDateKey: data[db_key.multiDateDBKey],
        soldOutDate: data[db_key.soldOutDateDBKey] == null
            ? null
            : data[db_key.soldOutDateDBKey].toDate());
  }

  final String id;
  final String imageSrc;
  final List<dynamic> multiImageSrc;
  final String title;
  final String address;
  final num price;
  final DateTime date;
  final num duration;
  final num daysCancelBy;
  final List<dynamic> guestIds;
  final int capacity;
  final String hostId;
  final String description;
  final String hostContact;
  final List<dynamic> categories;
  final String city;
  final List<dynamic> reviews;
  final String cancellationPolicy;
  final List<dynamic> additionalInfo;
  final GeoPoint geoPoint;
  final bool eventCancelled;
  final String multiDateKey;
  String userRelation;
  final DateTime soldOutDate;
}

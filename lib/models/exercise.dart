import 'package:cloud_firestore/cloud_firestore.dart';
import '../copyDeck.dart' as copy;
import '../dbKeys.dart' as db_key;

class Exercise {
  Exercise(
      {this.id,
        this.imageSrc,
        this.name,
        this.date,
        this.repetitions,
      });

  factory Exercise.fromFireStore(DocumentSnapshot doc) {
    final data = doc.data;
    print(doc.data);
    return Exercise(
        id: doc.documentID,
        imageSrc: '',
        date: data['date'].toDate(),
        name: data['Description'],
        repetitions: data['Repetitions']);
  }

  final String id;
  final String imageSrc;
  final String name;
  final DateTime date;
  final int repetitions;
}

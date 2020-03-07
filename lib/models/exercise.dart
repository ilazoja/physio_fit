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
        this.type,
        this.sets,
        this.patientId,
      });

  factory Exercise.fromFireStore(DocumentSnapshot doc) {
    final data = doc.data;
    print(doc.data);
    return Exercise(
        id: doc.documentID,
        imageSrc: '',
        date: data['date'].toDate(),
        name: data['Name'],
        repetitions: data['Repetitions'],
        type: data['type'],
        sets: data['Sets'],
        patientId: data['userId']);
  }

  final String id;
  final String imageSrc;
  final String name;
  final DateTime date;
  final int repetitions;
  final int sets;
  final String type;
  final String patientId;
}

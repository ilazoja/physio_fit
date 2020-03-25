import 'package:cloud_firestore/cloud_firestore.dart';
import '../copyDeck.dart' as copy;
import '../dbKeys.dart' as db_key;

class CompletedExercise {
  CompletedExercise(
      {this.id,
        this.attemped_reps,
        this.correct_reps,
        this.reps_per_set,
        this.results,
        this.sets,
        this.total_reps,
        this.workout_time,
        this.name,
        this.correct_reps_array,
        this.total_reps_array
      });

  factory CompletedExercise.fromFireStore(DocumentSnapshot doc) {
    final data = doc.data;
    return CompletedExercise(
        id: doc.documentID,
        attemped_reps: data['attemped_reps'],
        correct_reps: data['correct_reps'],
        reps_per_set: data['reps_per_set'],
        results: data['results'],
        sets: data['sets'],
        total_reps: data['total_reps'],
        workout_time: data['workout_time'],
        name: data['name'],
        correct_reps_array: data['correct_reps_array'],
        total_reps_array: data['total_reps_array']);
  }
  final String id;
  final String name;
  final int attemped_reps;
  final int correct_reps;
  final int reps_per_set;
  final dynamic results;
  final int sets;
  final int total_reps;
  final int workout_time;
  final dynamic correct_reps_array;
  final dynamic total_reps_array;
}

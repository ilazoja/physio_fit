import 'package:cloud_firestore/cloud_firestore.dart';
import '../copyDeck.dart' as copy;
import '../dbKeys.dart' as db_key;

class CompletedExercise {
  CompletedExercise({
    this.id,
    this.attemped_reps,
    this.correct_reps,
    this.reps_per_set,
    this.results,
    this.sets,
    this.total_reps,
    this.workout_time,
    this.name,
    this.names,
    this.correct_reps_h,
    this.correct_reps_k,
    this.correct_reps_s,
    this.total_reps_array,
    this.h_sets,
    this.k_sets,
    this.s_sets,
    this.attempted_h,
    this.attempted_k,
    this.attempted_s,
    this.score_h,
    this.score_k,
    this.score_s,
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
      s_sets: data['s_sets'],
      total_reps: data['total_reps'],
      workout_time: data['workout_time'],
      name: data['name'],
      names: data['names'],
      correct_reps_h: data['correct_reps_h'],
      correct_reps_k: data['correct_reps_k'],
      correct_reps_s: data['correct_reps_s'],
      total_reps_array: data['total_reps_array'],
      h_sets: data['h_sets'],
      k_sets: data['k_sets'],
      attempted_h: data['attempted_h'],
      attempted_k: data['attempted_k'],
      attempted_s: data['attempted_s'],
      score_h: data['score_h'],
      score_k: data['score_k'],
      score_s: data['score_s'],
    );
  }
  final String id;
  final String name;
  final dynamic names;
  final int attemped_reps;
  final int correct_reps;
  final int reps_per_set;
  final dynamic results;
  final int sets;
  final int total_reps;
  final int workout_time;
  final dynamic correct_reps_h;
  final dynamic correct_reps_k;
  final dynamic correct_reps_s;
  final dynamic total_reps_array;
  final int h_sets;
  final int k_sets;
  final int s_sets;
  final dynamic attempted_h;
  final dynamic attempted_k;
  final dynamic attempted_s;
  final dynamic score_h;
  final dynamic score_k;
  final dynamic score_s;
}

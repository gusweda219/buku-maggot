import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  Note(
      {required this.timestamp,
      required this.seeds,
      required this.materialType,
      required this.materialWeight,
      required this.maggot,
      required this.kasgot});

  final Timestamp timestamp;
  final double seeds;
  final String materialType;
  final double materialWeight;
  final double maggot;
  final double kasgot;
}

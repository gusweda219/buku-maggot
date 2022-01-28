import 'package:buku_maggot_app/utils/model/note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cycle {
  Cycle({this.notes, required this.timeStamp, required this.isClose});

  final List<Note>? notes;
  final Timestamp timeStamp;
  final bool isClose;
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Cycle {
  Cycle({required this.timeStamp, required this.isClose});

  final Timestamp timeStamp;
  final bool isClose;
}

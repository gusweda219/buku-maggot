import 'package:cloud_firestore/cloud_firestore.dart';

class Biopond {
  Biopond(
      {this.id,
      required this.name,
      required this.length,
      required this.width,
      required this.height,
      required this.timestamp});

  String? id;
  final String name;
  final double length;
  final double width;
  final double height;
  final Timestamp timestamp;
}

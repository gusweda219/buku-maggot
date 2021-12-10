import 'package:buku_maggot_app/utils/model/biopond.dart';

class BiopondDetail extends Biopond {
  BiopondDetail(
      {required this.id,
      required this.totalMaggot,
      required this.totalMaterial,
      required name,
      required length,
      required width,
      required height,
      required timestamp})
      : super(
            name: name,
            length: length,
            width: width,
            height: height,
            timestamp: timestamp);

  final String id;
  final double totalMaggot;
  final double totalMaterial;
}

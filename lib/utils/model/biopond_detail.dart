import 'package:buku_maggot_app/utils/model/biopond.dart';
import 'package:buku_maggot_app/utils/model/cycle.dart';

class BiopondDetail extends Biopond {
  BiopondDetail(
      {String? id,
      required this.totalMaggot,
      required this.totalMaterial,
      required name,
      required length,
      required width,
      required height,
      required timestamp,
      required this.cyles})
      : super(
            id: id,
            name: name,
            length: length,
            width: width,
            height: height,
            timestamp: timestamp);

  final double totalMaggot;
  final double totalMaterial;
  final List<Cycle> cyles;
}

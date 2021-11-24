import 'package:buku_maggot_app/utils/model/biopond.dart';
import 'package:buku_maggot_app/utils/model/cycle.dart';
import 'package:buku_maggot_app/utils/model/note.dart';
import 'package:buku_maggot_app/utils/model/transaction.dart'
    as transaction_model;
import 'package:buku_maggot_app/utils/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class FirestoreDatabase {
  static Future<void> addTransaction(
      String uid, transaction_model.Transaction transaction) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .add({
      'type': transaction.type,
      'total': transaction.total,
      'note': transaction.note,
      'timeStamp': transaction.timestamp,
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getDataTransactions(
      String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }

  static Future<void> addUser(String uid, User user) {
    return _firestore.collection('users').doc(uid).set({
      'name': user.name,
      'phoneNumber': user.phoneNumber,
      'address': user.address,
    });
  }

  static Future<void> updateUser(String uid, User user) {
    return _firestore.collection('users').doc(uid).update({
      'name': user.name,
      'phoneNumber': user.phoneNumber,
      'address': user.address,
    });
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String uid) {
    return _firestore.collection('users').doc(uid).get();
  }

  static Future<void> addBiopond(String uid, Biopond biopond) {
    return _firestore.collection('users').doc(uid).collection('bioponds').add({
      'name': biopond.name,
      'length': biopond.length,
      'width': biopond.width,
      'height': biopond.height,
      'timeStamp': biopond.timestamp,
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getBioponds(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('bioponds')
        .orderBy('timeStamp')
        .snapshots();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getCycle(
      String uid, String bid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('bioponds')
        .doc(bid)
        .collection('cycles')
        .where('isClose', isEqualTo: false)
        .get();
  }

  static Future<DocumentReference> addCycle(
      String uid, String bid, Cycle cycle) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('bioponds')
        .doc(bid)
        .collection('cycles')
        .add({
      'timeStamp': cycle.timeStamp,
      'isClose': cycle.isClose,
    });
  }

  static Future<void> addBiopondNote(
      String uid, String bid, String cid, Note note) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('bioponds')
        .doc(bid)
        .collection('cycles')
        .doc(cid)
        .collection('notes')
        .add({
      'timeStamp': note.timestamp,
      'seeds': note.seeds,
      'materialType': note.materialType,
      'materialWeight': note.materialWeight,
      'maggot': note.maggot,
      'kasgot': note.kasgot,
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getBiopondNotes(
      String uid, String bid, String cid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('bioponds')
        .doc(bid)
        .collection('cycles')
        .doc(cid)
        .collection('notes')
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }
}

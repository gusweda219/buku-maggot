import 'package:buku_maggot_app/utils/model/transaction.dart'
    as transaction_model;
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
}
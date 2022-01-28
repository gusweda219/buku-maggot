import 'package:buku_maggot_app/utils/model/biopond.dart';
import 'package:buku_maggot_app/utils/model/biopond_detail.dart';
import 'package:buku_maggot_app/utils/model/cycle.dart';
import 'package:buku_maggot_app/utils/model/note.dart';
import 'package:buku_maggot_app/utils/model/transaction.dart'
    as transaction_model;
import 'package:buku_maggot_app/utils/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;

class FirestoreDatabase {
  // static Source source = Source.cache;

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

  static Future<void> deleteTransaction(String uid, String transactionId) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .doc(transactionId)
        .delete();
  }

  static Future<void> updateTransaction(
      String uid, transaction_model.Transaction transaction) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .doc(transaction.id)
        .update({
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

  static Future<void> updateBiopond(String uid, Biopond biopond) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('bioponds')
        .doc(biopond.id)
        .update({
      'name': biopond.name,
      'length': biopond.length,
      'width': biopond.width,
      'height': biopond.height,
    });
  }

  static Future<void> deleteBiopond(String uid, String idBiopond) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('bioponds')
        .doc(idBiopond)
        .delete();
  }

  static Stream<List<BiopondDetail>> getBioponds(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('bioponds')
        .orderBy('timeStamp')
        .snapshots()
        .asyncMap((snapshot) async {
      List<BiopondDetail> listBioponds = [];
      for (var biopond in snapshot.docs) {
        var maggot = 0.0;
        var material = 0.0;
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('bioponds')
            .doc(biopond.id)
            .collection('cycles')
            .get()
            .then((cycles) async {
          List<Cycle> listCycles = [];
          for (var cycle in cycles.docs) {
            await _firestore
                .collection('users')
                .doc(uid)
                .collection('bioponds')
                .doc(biopond.id)
                .collection('cycles')
                .doc(cycle.id)
                .collection('notes')
                .orderBy('timeStamp', descending: false)
                .get()
                .then((notes) {
              List<Note> listNotes = [];
              for (var note in notes.docs) {
                listNotes.add(Note(
                    timestamp: note.data()['timeStamp'],
                    seeds: note.data()['seeds'],
                    materialType: note.data()['materialType'],
                    materialWeight: note.data()['materialWeight'],
                    maggot: note.data()['maggot'],
                    kasgot: note.data()['kasgot']));
                maggot += note.data()['maggot'];
                material += note.data()['materialWeight'];
              }
              listCycles.add(Cycle(
                  notes: listNotes,
                  timeStamp: cycle.data()['timeStamp'],
                  isClose: cycle.data()['isClose']));
            });
          }
          listBioponds.add(BiopondDetail(
              id: biopond.id,
              totalMaggot: maggot,
              totalMaterial: material,
              name: biopond.data()['name'],
              length: biopond.data()['length'],
              width: biopond.data()['width'],
              height: biopond.data()['height'],
              timestamp: biopond.data()['timeStamp'],
              cyles: listCycles));
        });
      }
      return listBioponds;
    });
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
        .orderBy('timeStamp', descending: false)
        .snapshots();
  }

  static Future<void> updateStatusCycle(String uid, String bid, String cid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('bioponds')
        .doc(bid)
        .collection('cycles')
        .doc(cid)
        .update({
      'isClose': true,
      'closeTimeStamp': Timestamp.now(),
    });
  }

  static Future<List<Map<String, dynamic>>> getRiwayat(String uid, String bid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('bioponds')
        .doc(bid)
        .collection('cycles')
        .where('isClose', isEqualTo: true)
        .get()
        .then((cycles) async {
      var listCycles = <Map<String, dynamic>>[];
      for (var cycle in cycles.docs) {
        var seeds = 0.0;
        var materialWeight = 0.0;
        var maggot = 0.0;
        var kasgot = 0.0;
        late Timestamp startDate;
        late Timestamp endDate;
        List<Note> listNote = [];

        await _firestore
            .collection('users')
            .doc(uid)
            .collection('bioponds')
            .doc(bid)
            .collection('cycles')
            .doc(cycle.id)
            .collection('notes')
            .get()
            .then((notes) {
          startDate = notes.docs.first.data()['timeStamp'];
          endDate = notes.docs.last.data()['timeStamp'];

          for (var note in notes.docs) {
            listNote.add(Note(
                timestamp: note.data()['timeStamp'],
                seeds: note.data()['seeds'],
                materialType: note.data()['materialType'],
                materialWeight: note.data()['materialWeight'],
                maggot: note.data()['maggot'],
                kasgot: note.data()['kasgot']));
            seeds += note.data()['seeds'];
            materialWeight += note.data()['materialWeight'];
            maggot += note.data()['maggot'];
            kasgot += note.data()['kasgot'];
          }
        });

        listCycles.add({
          'seeds': seeds,
          'materialWeight': materialWeight,
          'maggot': maggot,
          'kasgot': kasgot,
          'startDate': startDate,
          'endDate': endDate,
          'notes': listNote,
        });
      }

      return listCycles;
    });
  }
}

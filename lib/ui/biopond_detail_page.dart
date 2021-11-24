import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/ui/add_biopond_note_page.dart';
import 'package:buku_maggot_app/utils/firestore_database.dart';
import 'package:buku_maggot_app/utils/model/cycle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class BiopondDetailPage extends StatefulWidget {
  static const routeName = '/biopond_detail_page';
  final String bid;

  BiopondDetailPage({Key? key, required this.bid}) : super(key: key);

  @override
  State<BiopondDetailPage> createState() => _BiopondDetailPageState();
}

class _BiopondDetailPageState extends State<BiopondDetailPage> {
  String? cid;

  late User _user;

  late NotesDataSource notesDataSource;

  void _loadUser() {
    var currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      _user = currentUser;
    }
  }

  void getCycle() async {
    try {
      final snapshot = await FirestoreDatabase.getCycle(_user.uid, widget.bid);
      if (snapshot.docs.isEmpty) {
        print('empty');
        final docRef = await FirestoreDatabase.addCycle(
            _user.uid,
            widget.bid,
            Cycle(
              timeStamp: Timestamp.fromMicrosecondsSinceEpoch(
                  DateTime.now().microsecondsSinceEpoch),
              isClose: false,
            ));
        print(docRef.id);
        setState(() {
          cid = docRef.id;
        });
      } else {
        print('not empty');
        print(snapshot.docs.first.id);
        setState(() {
          cid = snapshot.docs.first.id;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
    getCycle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text('Biopond'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Row(
                    children: const [
                      Icon(
                        Icons.history_edu_rounded,
                        color: primaryColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Riwayat Siklus'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  child: Row(
                    children: const [
                      Icon(
                        Icons.check_circle_outline_sharp,
                        color: primaryColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Tutup Siklus'),
                    ],
                  ),
                ),
              ];
            },
          )
        ],
      ),
      body: Builder(builder: (context) {
        if (cid == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream:
              FirestoreDatabase.getBiopondNotes(_user.uid, widget.bid, cid!),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data!.size == 0) {
                return Text('Data Kosong');
              }

              notesDataSource = NotesDataSource(notesData: snapshot.data!.docs);

              return SfDataGridTheme(
                data: SfDataGridThemeData(
                  frozenPaneElevation: 0,
                  frozenPaneLineWidth: 1,
                ),
                child: SfDataGrid(
                  source: notesDataSource,
                  columnWidthMode: ColumnWidthMode.auto,
                  frozenColumnsCount: 1,
                  columns: [
                    GridColumn(
                      columnName: 'date',
                      label: Container(
                        padding: EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Tanggal',
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'seeds',
                      label: Container(
                        padding: EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Bibit',
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'materialType',
                      label: Container(
                        padding: EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Tipe Bahan Baku',
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'materialWeight',
                      label: Container(
                        padding: EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Berat Bahan Baku',
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'maggot',
                      label: Container(
                        padding: EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Panen Maggot',
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'kasgot',
                      label: Container(
                        padding: EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Panen Kasgot',
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        );
      }),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () {
          Navigator.pushNamed(context, AddBiopondNotePage.routeName,
              arguments: {
                'bid': widget.bid,
                'cid': cid!,
              });
        },
        icon: const Icon(Icons.add),
        label: Text(
          'Tambah Catatan',
          style: styleLabelTransaction.copyWith(
            color: Colors.white,
            letterSpacing: 0,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        highlightElevation: 0,
      ),
    );
  }
}

class NotesDataSource extends DataGridSource {
  NotesDataSource(
      {required List<QueryDocumentSnapshot<Map<String, dynamic>>> notesData}) {
    _notesData = notesData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'date',
                  value: DateFormat.yMMMMd('id').format(DateTime.parse(
                      (e.data()['timeStamp'] as Timestamp)
                          .toDate()
                          .toString()))),
              DataGridCell<double>(
                  columnName: 'seeds', value: e.data()['seeds']),
              DataGridCell<String>(
                  columnName: 'materialType', value: e.data()['materialType']),
              DataGridCell<double>(
                  columnName: 'materialWeight',
                  value: e.data()['materialWeight']),
              DataGridCell<double>(
                  columnName: 'maggot', value: e.data()['maggot']),
              DataGridCell<double>(
                  columnName: 'kasgot', value: e.data()['kasgot']),
            ]))
        .toList();
  }

  List<DataGridRow> _notesData = [];

  @override
  List<DataGridRow> get rows => _notesData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}

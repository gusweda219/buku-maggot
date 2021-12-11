import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/ui/add_biopond_note_page.dart';
import 'package:buku_maggot_app/ui/main_page.dart';
import 'package:buku_maggot_app/ui/riwayat_biopond_page.dart';
import 'package:buku_maggot_app/utils/firestore_database.dart';
import 'package:buku_maggot_app/utils/model/cycle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class BiopondDetailPage extends StatefulWidget {
  static const routeName = '/biopond_detail_page';
  final String bid;

  const BiopondDetailPage({Key? key, required this.bid}) : super(key: key);

  @override
  State<BiopondDetailPage> createState() => _BiopondDetailPageState();
}

class _BiopondDetailPageState extends State<BiopondDetailPage> {
  String? cid;

  late User _user;

  bool _enableCycle = false;

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
        title: Text(
          'Biopond',
          style: appBarStyle,
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, RiwayatBiopondPage.routeName,
                          arguments: widget.bid);
                    },
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
                ),
                PopupMenuItem(
                  enabled: _enableCycle,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (_enableCycle) {
                        Navigator.pop(context);
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.confirm,
                            title: 'Anda ingin menutup siklus?',
                            text:
                                'Jika anda sudah menutup siklus, anda tidak dapat mengubahnya lagi',
                            confirmBtnText: 'Tutup',
                            cancelBtnText: 'Batal',
                            onConfirmBtnTap: () async {
                              Navigator.pop(context);
                              try {
                                await FirestoreDatabase.updateStatusCycle(
                                    _user.uid, widget.bid, cid!);
                                print('success');
                                Navigator.pop(context);
                              } catch (e) {
                                print('gagal');
                              }
                            });
                      }
                    },
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
              if (snapshot.data!.docs.isEmpty) {
                _enableCycle = false;
                return Center(child: Text('Data Kosong'));
              }

              notesDataSource = NotesDataSource(notesData: snapshot.data!.docs);

              _enableCycle = true;

              return SfDataGridTheme(
                data: SfDataGridThemeData(
                  frozenPaneElevation: 0,
                  frozenPaneLineWidth: 1,
                ),
                child: SfDataGrid(
                  source: notesDataSource,
                  frozenColumnsCount: 1,
                  defaultColumnWidth: 140,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
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
                          'Bibit (kg)',
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
                          'Berat Bahan Baku (kg)',
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
                          'Panen Maggot (kg)',
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
                          'Panen Kasgot (kg)',
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
              DataGridCell<String>(
                  columnName: 'seeds',
                  value: e.data()['seeds'] == 0
                      ? '-'
                      : _formatNumber(e.data()['seeds'])),
              DataGridCell<String>(
                  columnName: 'materialType',
                  value: e.data()['materialType'].isEmpty
                      ? '-'
                      : e.data()['materialType']),
              DataGridCell<String>(
                  columnName: 'materialWeight',
                  value: e.data()['materialWeight'] == 0
                      ? '-'
                      : _formatNumber(e.data()['materialWeight'])),
              DataGridCell<String>(
                  columnName: 'maggot',
                  value: e.data()['maggot'] == 0
                      ? '-'
                      : _formatNumber(e.data()['maggot'])),
              DataGridCell<String>(
                  columnName: 'kasgot',
                  value: e.data()['kasgot'] == 0
                      ? '-'
                      : _formatNumber(e.data()['kasgot'])),
            ]))
        .toList();
  }

  String _formatNumber(double number) {
    var formatter = NumberFormat("#,##0", "pt_BR");

    if (number % 1 == 0) {
      return formatter.format(number);
    } else {
      var arr = number.toStringAsFixed(2).split('.');
      return formatter.format(int.parse(arr[0])).toString() + ',' + arr[1];
    }
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

import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/utils/model/note.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class RiwayatBiopondDetailPage extends StatefulWidget {
  static const routeName = '/riwayat_biopond_detail_page';
  final List<Note> notes;

  const RiwayatBiopondDetailPage({Key? key, required this.notes})
      : super(key: key);

  @override
  State<RiwayatBiopondDetailPage> createState() =>
      _RiwayatBiopondDetailPageState();
}

class _RiwayatBiopondDetailPageState extends State<RiwayatBiopondDetailPage> {
  late NotesDataSource notesDataSource;

  @override
  void initState() {
    super.initState();
    notesDataSource =
        NotesDataSource(notesData: widget.notes.reversed.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text('Riwayat Biopond'),
        centerTitle: true,
      ),
      body: SfDataGridTheme(
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
      ),
    );
  }
}

class NotesDataSource extends DataGridSource {
  NotesDataSource({required List<Note> notesData}) {
    _notesData = notesData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'date',
                  value: DateFormat.yMMMMd('id')
                      .format(DateTime.parse(e.timestamp.toDate().toString()))),
              DataGridCell<double>(columnName: 'seeds', value: e.seeds),
              DataGridCell<String>(
                  columnName: 'materialType', value: e.materialType),
              DataGridCell<double>(
                  columnName: 'materialWeight', value: e.materialWeight),
              DataGridCell<double>(columnName: 'maggot', value: e.maggot),
              DataGridCell<double>(columnName: 'kasgot', value: e.kasgot),
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

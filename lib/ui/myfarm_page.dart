import 'dart:async';
import 'dart:io';

import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/ui/add_biopond_page.dart';
import 'package:buku_maggot_app/ui/biopond_detail_page.dart';
import 'package:buku_maggot_app/ui/edit_biopond_page.dart';
import 'package:buku_maggot_app/utils/firestore_database.dart';
import 'package:buku_maggot_app/utils/model/biopond.dart';
import 'package:buku_maggot_app/utils/model/biopond_detail.dart';
import 'package:buku_maggot_app/utils/model/note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

class MyFarmPage extends StatefulWidget {
  static const routeName = '/myfarm_page';

  MyFarmPage({Key? key}) : super(key: key);

  @override
  State<MyFarmPage> createState() => _MyFarmPageState();
}

class _MyFarmPageState extends State<MyFarmPage> {
  late User _user;
  late List<BiopondDetail> _listBiopond;

  void _loadUser() {
    var currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      _user = currentUser;
    }
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

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          'Farmku',
          style: appBarStyle,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<BiopondDetail>>(
          stream: FirestoreDatabase.getBioponds(_user.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.length == 0) {
              return Center(
                child: Text('Data Kosong'),
              );
            } else {
              _listBiopond = snapshot.data!;

              var maggot = 0.0;
              var material = 0.0;

              for (var biopond in snapshot.data!) {
                maggot += biopond.totalMaggot;
                material += biopond.totalMaterial;
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 140,
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              width: MediaQuery.of(context).size.width,
                              height: 140,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Total Bahan Baku',
                                                  style: styleLabelTransaction,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  '${_formatNumber(material)} Kg',
                                                  style: styleValueTransaction
                                                      .copyWith(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const VerticalDivider(
                                            color: Colors.black,
                                            thickness: 1,
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Total Panen Maggot',
                                                  style: styleLabelTransaction,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  '${_formatNumber(maggot)} Kg',
                                                  style: styleValueTransaction
                                                      .copyWith(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                    indent: 15,
                                    endIndent: 15,
                                    thickness: 1,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Material(
                                        child: InkWell(
                                          onTap: () {
                                            showMaterialModalBottomSheet(
                                                context: context,
                                                builder: (context) => Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        const SizedBox(
                                                          height: 12,
                                                        ),
                                                        Text(
                                                          'Pilih format laporan',
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        ListTile(
                                                            title: const Text(
                                                                'PDF'),
                                                            leading:
                                                                Image.asset(
                                                              'images/pdf.png',
                                                              width: 24,
                                                            ),
                                                            onTap: () =>
                                                                _createPDF()),
                                                        ListTile(
                                                          title: const Text(
                                                              'Excel'),
                                                          leading: Image.asset(
                                                            'images/xls.png',
                                                            width: 24,
                                                          ),
                                                          onTap: () =>
                                                              _createExcel(),
                                                        ),
                                                      ],
                                                    ));
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.bar_chart_rounded),
                                              Text(
                                                'Laporan',
                                                style: GoogleFonts.montserrat(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      shrinkWrap: true,
                      primary: false,
                      padding: const EdgeInsets.all(13),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return containerGridView(
                            context: context,
                            // name: snapshot.data!.bioponds[index].name,
                            // date: DateFormat.yMMMMd('id').format(DateTime.parse(
                            //     snapshot.data!.bioponds[index].timestamp
                            //         .toDate()
                            //         .toString())),
                            biopond: snapshot.data![index],
                            onTap: () {
                              Navigator.pushNamed(
                                      context, BiopondDetailPage.routeName,
                                      arguments: snapshot.data![index].id)
                                  .then((_) {
                                setState(() {});
                              });
                            });
                      },
                    ),
                    SizedBox(
                      height: 120,
                    ),
                  ],
                ),
              );
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: 15,
            bottom: 60,
            child: FloatingActionButton.extended(
              heroTag: null,
              onPressed: () {
                Navigator.pushNamed(context, AddBiopondPage.routeName);
              },
              icon: const Icon(Icons.add),
              label: Text(
                'Tambah Biopond',
                style: styleLabelTransaction.copyWith(
                  color: Colors.white,
                  letterSpacing: 0,
                ),
              ),
              backgroundColor: primaryColor,
              elevation: 0,
              highlightElevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget containerGridView({
    required final BuildContext context,
    required final BiopondDetail biopond,
    required final Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, EditBiopondPage.routeName,
                      arguments: Biopond(
                          id: biopond.id,
                          name: biopond.name,
                          length: biopond.length,
                          width: biopond.width,
                          height: biopond.height,
                          timestamp: biopond.timestamp));
                },
                icon: Icon(
                  Icons.settings,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    biopond.name,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    DateFormat.yMMMMd('id').format(
                        DateTime.parse(biopond.timestamp.toDate().toString())),
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                    ),
                  ),
                  Divider(
                    color: Colors.grey[400],
                  ),
                  Text(
                    'Bahan Baku',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${_formatNumber(biopond.totalMaterial)} kg',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Panen Maggot',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${_formatNumber(biopond.totalMaggot)} kg',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();

    for (var biopond in _listBiopond) {
      final PdfPage page = document.pages.add();

      page.graphics.drawString('Laporan ${biopond.name}',
          PdfStandardFont(PdfFontFamily.helvetica, 16));

      var endDate = DateFormat.yMMMMd('id')
          .format(DateTime.parse(Timestamp.now().toDate().toString()));

      var startDate = DateFormat.yMMMMd('id')
          .format(DateTime.parse(biopond.timestamp.toDate().toString()));

      page.graphics.drawString(
          'Tanggal laporan', PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(0, 30, 0, 0));

      page.graphics.drawString(': $startDate - $endDate',
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(150, 30, 0, 0));

      page.graphics.drawString(
          'Total Bahan Baku', PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(0, 45, 0, 0));

      page.graphics.drawString(': ${biopond.totalMaterial} Kg',
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(150, 45, 0, 0));

      page.graphics.drawString(
          'Total Panen Maggot', PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(0, 60, 0, 0));

      page.graphics.drawString(': ${biopond.totalMaggot} Kg',
          PdfStandardFont(PdfFontFamily.helvetica, 12),
          bounds: Rect.fromLTWH(150, 60, 0, 0));

      double height = 120;
      for (var cycle in biopond.cyles) {
        final PdfGrid grid = getGrid(cycle.notes!);

        page.graphics.drawString(
            'Status', PdfStandardFont(PdfFontFamily.helvetica, 12),
            bounds: Rect.fromLTWH(0, height - 15, 0, 0));
        page.graphics.drawString(
            ': ${cycle.isClose ? 'Sudah Selesai' : 'Masih Berjalan'}',
            PdfStandardFont(PdfFontFamily.helvetica, 12),
            bounds: Rect.fromLTWH(50, height - 15, 0, 0));

        height = grid
                .draw(page: page, bounds: Rect.fromLTWH(0, height, 0, 0))!
                .bounds
                .height +
            height +
            30;
      }
    }

    List<int> bytes = document.save();
    document.dispose();

    final path = (await getApplicationDocumentsDirectory()).path;
    final String fileName =
        '$path/Laporan Buku Maggot_${DateFormat.yMMMMd('id').format(DateTime.now())}.pdf';
    final file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }

  // Create PDF grid and return
  PdfGrid getGrid(List<Note> notes) {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 6);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Tanggal';
    headerRow.cells[1].value = 'Bibit';
    headerRow.cells[2].value = 'Tipe Bahan Baku';
    headerRow.cells[3].value = 'Berat Bahan Baku (Kg)';
    headerRow.cells[4].value = 'Panen Maggot (Kg)';
    headerRow.cells[5].value = 'Panen Kasgot (Kg)';
    //Add rows
    addMaggot(grid, notes);
    //Apply the table built-in style
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    //Set gird columns width
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  // Create and row for the grid.
  void addMaggot(PdfGrid grid, List<Note> notes) {
    for (var element in notes) {
      final PdfGridRow row = grid.rows.add();
      row.cells[0].value = DateFormat.yMMMMd('id')
          .format(DateTime.parse(element.timestamp.toDate().toString()));
      row.cells[1].value =
          element.seeds == 0 ? '-' : _formatNumber(element.seeds);
      row.cells[2].value =
          element.materialType.trim().isEmpty ? '-' : element.materialType;
      row.cells[3].value = element.materialWeight == 0
          ? '-'
          : _formatNumber(element.materialWeight);
      row.cells[4].value =
          element.maggot == 0 ? '-' : _formatNumber(element.maggot);
      row.cells[5].value =
          element.kasgot == 0 ? '-' : _formatNumber(element.kasgot);
    }
  }

  Future<void> _createExcel() async {
    final xlsio.Workbook workbook = xlsio.Workbook(_listBiopond.length);

    for (var i = 0; i < _listBiopond.length; i++) {
      final xlsio.Worksheet sheet = workbook.worksheets[i];

      sheet.enableSheetCalculations();

      sheet.getRangeByName('A1').columnWidth = 4.82;
      sheet.getRangeByName('B1:E1').columnWidth = 13.82;

      sheet.getRangeByName('B4:D5').merge();

      sheet
          .getRangeByName('B4')
          .setText('Laporan Maggot ${_listBiopond[i].name}');
      sheet.getRangeByName('B4').cellStyle.fontSize = 20;

      var endDate = DateFormat.yMMMMd('id')
          .format(DateTime.parse(Timestamp.now().toDate().toString()));

      var startDate = DateFormat.yMMMMd('id').format(
          DateTime.parse(_listBiopond[i].timestamp.toDate().toString()));

      sheet.getRangeByName('C9:D9').merge();
      sheet.getRangeByName('C9').setText('$startDate - $endDate');
      sheet.getRangeByName('C9').cellStyle.fontSize = 9;

      sheet.getRangeByName('B9').setText('Tanggal Laporan');
      sheet.getRangeByName('B9').cellStyle.fontSize = 9;

      sheet.getRangeByName('B10').setText('Total Bahan Baku');
      sheet.getRangeByName('B10').cellStyle.fontSize = 9;

      sheet.getRangeByName('C10').setNumber(_listBiopond[i].totalMaterial);
      sheet.getRangeByName('C10').cellStyle.fontSize = 9;
      sheet.getRangeByName('C10').cellStyle.hAlign = xlsio.HAlignType.left;

      sheet.getRangeByName('B11').setText('Total Panen Maggot');
      sheet.getRangeByName('B11').cellStyle.fontSize = 9;

      sheet.getRangeByName('C11').setNumber(_listBiopond[i].totalMaggot);
      sheet.getRangeByName('C11').cellStyle.fontSize = 9;
      sheet.getRangeByName('C11').cellStyle.hAlign = xlsio.HAlignType.left;

      var height = 15;
      for (var cycle in _listBiopond[i].cyles) {
        sheet.getRangeByIndex(height - 1, 2).setText('Status');
        sheet
            .getRangeByIndex(height - 1, 3)
            .setText(cycle.isClose ? "Sudah Selesai" : "Masih Berjalan");
        sheet.getRangeByIndex(height, 2).setText('Tanggal');
        sheet.getRangeByIndex(height, 3).setText('Bibit');
        sheet.getRangeByIndex(height, 4).setText('Tipe Bahan Baku');
        sheet.getRangeByIndex(height, 5).setText('Berat Bahan Baku (Kg)');
        sheet.getRangeByIndex(height, 6).setText('Panen Maggot (Kg)');
        sheet.getRangeByIndex(height, 7).setText('Panen Kasgot (Kg)');

        height += 1;
        for (var j = 0; j < cycle.notes!.length; j++) {
          sheet.getRangeByIndex(j + height, 2).setText(DateFormat.yMMMMd('id')
              .format(DateTime.parse(
                  cycle.notes![j].timestamp.toDate().toString())));
          sheet.getRangeByIndex(j + height, 2).cellStyle.hAlign =
              xlsio.HAlignType.left;

          sheet.getRangeByIndex(j + height, 3).setNumber(cycle.notes![j].seeds);
          sheet.getRangeByIndex(j + height, 3).cellStyle.hAlign =
              xlsio.HAlignType.left;

          sheet
              .getRangeByIndex(j + height, 4)
              .setText(cycle.notes![j].materialType);
          sheet.getRangeByIndex(j + height, 4).cellStyle.hAlign =
              xlsio.HAlignType.left;

          sheet
              .getRangeByIndex(j + height, 5)
              .setNumber(cycle.notes![j].materialWeight);
          sheet.getRangeByIndex(j + height, 5).cellStyle.hAlign =
              xlsio.HAlignType.left;

          sheet
              .getRangeByIndex(j + height, 6)
              .setNumber(cycle.notes![j].maggot);
          sheet.getRangeByIndex(j + height, 6).cellStyle.hAlign =
              xlsio.HAlignType.left;

          sheet
              .getRangeByIndex(j + height, 7)
              .setNumber(cycle.notes![j].kasgot);
          sheet.getRangeByIndex(j + height, 7).cellStyle.hAlign =
              xlsio.HAlignType.left;

          // sheet
          //     .getRangeByIndex(i + 16, 3)
          //     .setText(dataTransactions[i].data()['note']);
          // if (dataTransactions[i].data()['type'] == 'Pemasukan') {
          //   sheet
          //       .getRangeByIndex(i + 16, 4)
          //       .setNumber(dataTransactions[i].data()['total']);
          //   sheet.getRangeByIndex(i + 16, 4).cellStyle.hAlign =
          //       xlsio.HAlignType.left;
          // } else {
          //   sheet
          //       .getRangeByIndex(i + 16, 5)
          //       .setNumber(dataTransactions[i].data()['total']);
          //   sheet.getRangeByIndex(i + 16, 5).cellStyle.hAlign =
          //       xlsio.HAlignType.left;
          // }
        }

        height = height + cycle.notes!.length + 3;
      }
    }
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName =
        '$path/Laporan Buku Maggot_${DateFormat.yMMMMd('id').format(DateTime.now())}.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }
}

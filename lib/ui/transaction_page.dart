import 'dart:io';

import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/ui/edit_transaction_page.dart';
import 'package:buku_maggot_app/ui/transaction_form_page.dart';
import 'package:buku_maggot_app/utils/firestore_database.dart';
import 'package:buku_maggot_app/utils/model/transaction.dart' as ts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late User user;

  late List<QueryDocumentSnapshot<Map<String, dynamic>>> dataTransactions;

  void _loadUser() {
    var currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      user = currentUser;
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

  bool _isProfitOrLoss(double income, double expense) {
    if (income >= expense) {
      return true;
    } else {
      return false;
    }
  }

  List<Map<String, dynamic>> _groupTransactionByDate(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> data) {
    var value = data
        .fold(<String, List<dynamic>>{}, (Map<String, List<dynamic>> a, b) {
          a
              .putIfAbsent(
                  DateFormat.yMMMMd('id').format(DateTime.parse(
                      (b['timeStamp'] as Timestamp).toDate().toString())),
                  () => [])
              .add(b);
          return a;
        })
        .values
        .where((l) => (l).isNotEmpty)
        .map((l) => {
              'timeStamp': l.first['timeStamp'],
              'data': l
                  .map((e) => {
                        'id': e.id,
                        'type': e['type'],
                        'total': e['total'],
                        'note': e['note'],
                        'timeStamp': e['timeStamp'],
                      })
                  .toList()
            })
        .toList();
    return value;
  }

  Future<void> _createExcel() async {
    final xlsio.Workbook workbook = xlsio.Workbook();
    final xlsio.Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByIndex(1, 1).setText('halo');
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName =
        '$path/Laporan Laba Rugi_${DateFormat.yMMMMd('id').format(DateTime.now())}';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }

  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();

    final PdfPage page = document.pages.add();

    page.graphics.drawString(
        'Laporan Transaksi', PdfStandardFont(PdfFontFamily.helvetica, 16));

    var startDate = DateFormat.yMMMMd('id').format(DateTime.parse(
        dataTransactions.first.data()['timeStamp'].toDate().toString()));

    var endDate = DateFormat.yMMMMd('id').format(DateTime.parse(
        dataTransactions.last.data()['timeStamp'].toDate().toString()));

    page.graphics.drawString(
        'Tanggal laporan', PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: Rect.fromLTWH(0, 30, 0, 0));

    page.graphics.drawString(
        ': $startDate - $endDate', PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: Rect.fromLTWH(100, 30, 0, 0));

    page.graphics.drawString(
        'Pemasukan', PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: Rect.fromLTWH(0, 45, 0, 0));

    page.graphics.drawString(
        ': Rp. 10.000', PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: Rect.fromLTWH(100, 45, 0, 0));

    page.graphics.drawString(
        'Pengeluaran', PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: Rect.fromLTWH(0, 60, 0, 0));

    page.graphics.drawString(
        ': Rp. 10.000', PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: Rect.fromLTWH(100, 60, 0, 0));

    final PdfGrid grid = getGrid();
    // final PdfLayoutResult result = drawHeader(page, pageSize, grid);
    grid.draw(page: page, bounds: Rect.fromLTWH(0, 90, 0, 0));

    List<int> bytes = document.save();
    document.dispose();

    final path = (await getApplicationDocumentsDirectory()).path;
    final String fileName =
        '$path/Laporan Laba Rugi_${DateFormat.yMMMMd('id').format(DateTime.now())}';
    final file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }

  //Draws the grid
  void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
    Rect? totalPriceCellBounds;
    Rect? quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //Draw the PDF grid and get the result.
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0))!;

    //Draw grand total.
    page.graphics.drawString('Grand Total',
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            quantityCellBounds!.left,
            result.bounds.bottom + 10,
            quantityCellBounds!.width,
            quantityCellBounds!.height));
    // page.graphics.drawString(getTotalAmount(grid).toString(),
    //     PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
    //     bounds: Rect.fromLTWH(
    //         totalPriceCellBounds!.left,
    //         result.bounds.bottom + 10,
    //         totalPriceCellBounds!.width,
    //         totalPriceCellBounds!.height));
  }

  //Create PDF grid and return
  PdfGrid getGrid() {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 4);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Tanggal';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Catatan';
    headerRow.cells[2].value = 'Pemasukan';
    headerRow.cells[3].value = 'Pengeluaran';
    //Add rows
    addTransaction(grid);
    //Apply the table built-in style
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    //Set gird columns width
    grid.columns[1].width = 200;
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

  //Create and row for the grid.
  void addTransaction(PdfGrid grid) {
    for (var element in dataTransactions) {
      final PdfGridRow row = grid.rows.add();
      row.cells[0].value = DateFormat.yMMMMd('id').format(DateTime.parse(
          (element.data()['timeStamp'] as Timestamp).toDate().toString()));
      row.cells[1].value =
          element.data()['note'].trim().isEmpty ? '-' : element.data()['note'];
      if (element.data()['type'] == 'Pemasukan') {
        row.cells[2].value = 'Rp.${_formatNumber(element.data()['total'])}';
        row.cells[3].value = 'Rp.-';
      } else {
        row.cells[2].value = 'Rp.-';
        row.cells[3].value = 'Rp.${_formatNumber(element.data()['total'])}';
      }
    }
  }

  //Get the total amount.
  // double getTotalAmount(PdfGrid grid) {
  //   double total = 0;
  //   for (int i = 0; i < grid.rows.count; i++) {
  //     final String value =
  //         grid.rows[i].cells[grid.columns.count - 1].value as String;
  //     total += double.parse(value);
  //   }
  //   return total;
  // }

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
          'Transaksi',
          style: appBarStyle,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirestoreDatabase.getDataTransactions(user.uid),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Center(
          //     child: CircularProgressIndicator(),
          //   )
          // } else if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
          //   if (snapshot.hasError) {
          //     return Text("Something went wrong");
          //   } else if (snapshot.hasData) {

          //   }
          // // }
          // print(snapshot.connectionState);
          // if (snapshot.hasError) {
          //   return Text("Something went wrong");
          // }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('data kosong'),
            );
          } else {
            dataTransactions = snapshot.data!.docs;

            double income = 0;
            double expense = 0;

            for (var item in snapshot.data!.docs) {
              if (item['type'] == 'Pemasukan') {
                income += item['total'];
              } else {
                expense += item['total'];
              }
            }

            final value = _groupTransactionByDate(snapshot.data!.docs);

            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              child: SingleChildScrollView(
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
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Pemasukan',
                                            style: styleLabelTransaction,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Pengeluaran',
                                            style: styleLabelTransaction,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Rp. ${_formatNumber(income)}',
                                            style:
                                                styleValueTransaction.copyWith(
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Rp. ${_formatNumber(expense)}',
                                            style:
                                                styleValueTransaction.copyWith(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 10),
                                    color: _isProfitOrLoss(income, expense)
                                        ? Colors.green
                                        : Colors.red,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _isProfitOrLoss(income, expense)
                                                ? 'Keuntungan'
                                                : 'Kerugian',
                                            style:
                                                styleLabelTransaction.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _isProfitOrLoss(income, expense)
                                                ? 'Rp. ${_formatNumber(income - expense)}'
                                                : 'Rp. ${_formatNumber(expense - income)}',
                                            style:
                                                styleValueTransaction.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
                                                            title: Text('PDF'),
                                                            leading:
                                                                Image.asset(
                                                              'images/pdf.png',
                                                              width: 24,
                                                            ),
                                                            onTap: () =>
                                                                _createPDF()),
                                                        ListTile(
                                                          title: Text('Excel'),
                                                          leading: Image.asset(
                                                            'images/xls.png',
                                                            width: 24,
                                                          ),
                                                          onTap: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
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
                                  )
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
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: value.length,
                        itemBuilder: (contex, index) {
                          double incomeDate = 0;
                          double expenseDate = 0;

                          for (Map<String, dynamic> item in value[index]
                              ['data']) {
                            if (item['type'] == 'Pemasukan') {
                              incomeDate += item['total'];
                            } else {
                              expenseDate += item['total'];
                            }
                          }

                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  color: Colors.grey[300],
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(DateFormat.yMMMMd('id').format(
                                          DateTime.parse((value[index]
                                                  ['timeStamp'] as Timestamp)
                                              .toDate()
                                              .toString()))),
                                      Text(
                                        _isProfitOrLoss(incomeDate, expenseDate)
                                            ? 'Keuntungan Rp. ${_formatNumber(incomeDate - expenseDate)}'
                                            : 'Kerugian Rp. ${_formatNumber(expenseDate - incomeDate)}',
                                        style: TextStyle(
                                          color: _isProfitOrLoss(
                                                  incomeDate, expenseDate)
                                              ? Colors.green[700]
                                              : Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    children: const [
                                      Expanded(flex: 4, child: Text('Catatan')),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                            'Pemasukan',
                                            textAlign: TextAlign.end,
                                          )),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                            'Pengeluaran',
                                            textAlign: TextAlign.end,
                                          )),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: Colors.black,
                                  indent: 15,
                                  endIndent: 15,
                                  thickness: 1,
                                ),
                                ListView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children:
                                      value[index]['data'].map<Widget>((e) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(context,
                                            EditTransactionPage.routeName,
                                            arguments: {
                                              'typeForm': e['type'] ==
                                                      'Pemasukan'
                                                  ? EditTransactionPage.income
                                                  : EditTransactionPage.expense,
                                              'userId': user.uid,
                                              'transaction': ts.Transaction(
                                                id: e['id'],
                                                type: e['type'],
                                                total: e['total'],
                                                note: e['note'],
                                                timestamp: e['timeStamp'],
                                              )
                                            });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 4,
                                                child: Text(
                                                    (e['note'] as String)
                                                            .trim()
                                                            .isNotEmpty
                                                        ? e['note'].toString()
                                                        : '-')),
                                            Expanded(
                                                flex: 3,
                                                child: Text(
                                                  e['type'] == 'Pemasukan'
                                                      ? _formatNumber(
                                                          e['total'])
                                                      : '-',
                                                  style: GoogleFonts.montserrat(
                                                    color: Colors.green[700],
                                                  ),
                                                  textAlign: TextAlign.end,
                                                )),
                                            Expanded(
                                                flex: 3,
                                                child: Text(
                                                  e['type'] == 'Pengeluaran'
                                                      ? _formatNumber(
                                                          e['total'])
                                                      : '-',
                                                  style: GoogleFonts.montserrat(
                                                    color: Colors.red,
                                                  ),
                                                  textAlign: TextAlign.end,
                                                )),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                )
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            left: 15,
            bottom: 60,
            child: FloatingActionButton.extended(
              heroTag: null,
              onPressed: () => Navigator.pushNamed(
                  context, TransactionFormPage.routeName,
                  arguments: TransactionFormPage.income),
              icon: const Icon(Icons.south_west_rounded),
              label: Text(
                'Pemasukan',
                style: styleLabelTransaction.copyWith(
                  color: Colors.white,
                  letterSpacing: 0,
                ),
              ),
              backgroundColor: Colors.green,
              elevation: 0,
              highlightElevation: 0,
            ),
          ),
          Positioned(
            right: 15,
            bottom: 60,
            child: FloatingActionButton.extended(
              heroTag: null,
              onPressed: () => Navigator.pushNamed(
                  context, TransactionFormPage.routeName,
                  arguments: TransactionFormPage.expense),
              icon: const Icon(Icons.north_east_rounded),
              label: Text(
                'Pengeluaran',
                style: styleLabelTransaction.copyWith(
                  color: Colors.white,
                  letterSpacing: 0,
                ),
              ),
              backgroundColor: Colors.red,
              elevation: 0,
              highlightElevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}

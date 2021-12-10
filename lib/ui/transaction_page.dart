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
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
    document.pages.add();

    List<int> bytes = document.save();
    document.dispose();

    final path = (await getApplicationDocumentsDirectory()).path;
    final String fileName =
        '$path/Laporan Laba Rugi_${DateFormat.yMMMMd('id').format(DateTime.now())}';
    final file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
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
        title: const Text('Transaksi'),
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
          } else {
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
                                            _createPDF();
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

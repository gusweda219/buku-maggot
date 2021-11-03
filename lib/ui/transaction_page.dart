import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/ui/transaction_form_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text('Transaksi'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                      margin: const EdgeInsets.symmetric(horizontal: 15),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Rp. 50.000',
                                    style: styleValueTransaction.copyWith(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Rp. 10.000',
                                    style: styleValueTransaction.copyWith(
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
                            color: Colors.green,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Keuntungan',
                                    style: styleLabelTransaction.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Rp. 40.000',
                                    style: styleValueTransaction.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Icon(Icons.bar_chart_rounded),
                                Text(
                                  'Laporan',
                                  style: GoogleFonts.montserrat(),
                                ),
                              ],
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
            Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  color: Colors.grey[300],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('20 September 2021'),
                      Text('Keuntungan Rp. 10.000'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: const [
                      Expanded(flex: 4, child: Text('Pak Rudy')),
                      Expanded(
                          flex: 3,
                          child: Text(
                            '-',
                            textAlign: TextAlign.end,
                          )),
                      Expanded(
                          flex: 3,
                          child: Text(
                            'Rp. 10.000',
                            textAlign: TextAlign.end,
                          )),
                    ],
                  ),
                ),
                Container(
                  height: 1000,
                  width: MediaQuery.of(context).size.width,
                )
              ],
            )
          ],
        ),
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

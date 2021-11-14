import 'package:buku_maggot_app/common/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

class MyFarmPage extends StatelessWidget {
  static const routeName = '/myfarm_page';

  const MyFarmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text('Farmku'),
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
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Total Bahan Baku',
                                              style: styleLabelTransaction,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '4,5 Ton',
                                              style: styleValueTransaction
                                                  .copyWith(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  VerticalDivider(
                                    color: Colors.black,
                                    thickness: 1,
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Total Panen Maggot',
                                              style: styleLabelTransaction,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '3,5 Ton',
                                              style: styleValueTransaction
                                                  .copyWith(),
                                            ),
                                          ),
                                        ],
                                      ),
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
            GridView.count(
              shrinkWrap: true,
              primary: false,
              padding: EdgeInsets.all(13),
              crossAxisCount: 4,
              children: [
                containerGridView(
                  text: 'Biopond 1',
                ),
                containerGridView(text: 'Biopond 2'),
                containerGridView(text: 'Biopond 3'),
                containerGridView(text: 'Biopond 4'),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: 15,
            bottom: 60,
            child: FloatingActionButton.extended(
              heroTag: null,
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: Text(
                'Catatan Disini',
                style: styleLabelTransaction.copyWith(
                  color: Colors.white,
                  letterSpacing: 0,
                ),
              ),
              backgroundColor: Colors.orange,
              elevation: 0,
              highlightElevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget containerGridView({
    required String text,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 10,
      ),
      child: SizedBox(
        height: 100,
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

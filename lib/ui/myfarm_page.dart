import 'dart:async';

import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/ui/add_biopond_page.dart';
import 'package:buku_maggot_app/ui/biopond_detail_page.dart';
import 'package:buku_maggot_app/utils/firestore_database.dart';
import 'package:buku_maggot_app/utils/model/biopond_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MyFarmPage extends StatefulWidget {
  static const routeName = '/myfarm_page';

  MyFarmPage({Key? key}) : super(key: key);

  @override
  State<MyFarmPage> createState() => _MyFarmPageState();
}

class _MyFarmPageState extends State<MyFarmPage> {
  late User _user;
  // late StreamSubscription subscription;

  void _loadUser() {
    var currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      _user = currentUser;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
    // subscription = Connectivity()
    //     .onConnectivityChanged
    //     .listen((ConnectivityResult result) async {
    //   print('asd');
    //   var connectivityResult = await (Connectivity().checkConnectivity());
    //   if (connectivityResult == ConnectivityResult.none) {
    //     print('test');
    //     FirestoreDatabase.source = Source.cache;
    //   } else {
    //     print('test2');
    //     FirestoreDatabase.source = Source.serverAndCache;
    //   }
    // });
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
            } else {
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
                                                  '$material Kg',
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
                                                  '$maggot Kg',
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.bar_chart_rounded),
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
                onPressed: () {},
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
                    '${biopond.totalMaterial} kg',
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
                    '${biopond.totalMaggot} kg',
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

  // @override
  // void dispose() {
  //   subscription.cancel();
  //   super.dispose();
  // }
}

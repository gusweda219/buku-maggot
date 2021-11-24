import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/ui/add_biopond_page.dart';
import 'package:buku_maggot_app/ui/biopond_detail_page.dart';
import 'package:buku_maggot_app/utils/firestore_database.dart';
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

class MyFarmPage extends StatelessWidget {
  static const routeName = '/myfarm_page';

  late User _user;

  void _loadUser() {
    var currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      _user = currentUser;
    }
  }

  MyFarmPage({Key? key}) : super(key: key) {
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text('Farmku'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirestoreDatabase.getBioponds(_user.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
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
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Total Bahan Baku',
                                                      style:
                                                          styleLabelTransaction,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '4,5 Ton',
                                                      style:
                                                          styleValueTransaction
                                                              .copyWith(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const VerticalDivider(
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
                                                      style:
                                                          styleLabelTransaction,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '3,5 Ton',
                                                      style:
                                                          styleValueTransaction
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
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return containerGridView(
                            context: context,
                            name: snapshot.data!.docs[index]['name'],
                            date: DateFormat.yMMMMd('id').format(DateTime.parse(
                                (snapshot.data!.docs[index]['timeStamp']
                                        as Timestamp)
                                    .toDate()
                                    .toString())),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, BiopondDetailPage.routeName,
                                  arguments: snapshot.data!.docs[index].id);
                            });
                      },
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
    required final String name,
    required final String date,
    required final Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              Text(
                date,
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
                '10 kg',
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
                '10 kg',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

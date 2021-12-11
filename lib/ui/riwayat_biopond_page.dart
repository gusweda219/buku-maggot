import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/ui/riwayat_biopond_detail_page.dart';
import 'package:buku_maggot_app/utils/firestore_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RiwayatBiopondPage extends StatefulWidget {
  static const routeName = '/riwayat_biopond_page';
  final String bid;

  const RiwayatBiopondPage({Key? key, required this.bid}) : super(key: key);

  @override
  _RiwayatBiopondPageState createState() => _RiwayatBiopondPageState();
}

class _RiwayatBiopondPageState extends State<RiwayatBiopondPage> {
  late User _user;

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
        title: const Text('Riwayat Siklus'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
          future: FirestoreDatabase.getRiwayat(_user.uid, widget.bid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data!.length == 0) {
                return Center(child: Text('Data Kosong'));
              }
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                        context, RiwayatBiopondDetailPage.routeName,
                        arguments: snapshot.data![index]['notes']);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${DateFormat.yMMMMd('id').format(DateTime.parse((snapshot.data![index]['startDate'] as Timestamp).toDate().toString()))} - ${DateFormat.yMMMMd('id').format(DateTime.parse((snapshot.data![index]['endDate'] as Timestamp).toDate().toString()))}',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          color: Colors.grey.shade400,
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text('Bibit'),
                                      Text(
                                          '${_formatNumber(snapshot.data![index]['seeds'])} Kg')
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text('Bahan Baku'),
                                      Text(
                                          '${_formatNumber(snapshot.data![index]['materialWeight'])} Kg')
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text('Maggot'),
                                      Text(
                                          '${_formatNumber(snapshot.data![index]['maggot'])} Kg')
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text('Kasgot'),
                                      Text(
                                          '${_formatNumber(snapshot.data![index]['kasgot'])} Kg')
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}

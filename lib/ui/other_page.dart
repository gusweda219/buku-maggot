import 'package:buku_maggot_app/ui/alarm_page.dart';
import 'package:buku_maggot_app/ui/login_page.dart';
import 'package:buku_maggot_app/ui/profile_page.dart';
import 'package:buku_maggot_app/utils/firestore_database.dart';
import 'package:buku_maggot_app/utils/model/user.dart' as user_model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:buku_maggot_app/common/styles.dart';
import 'package:google_fonts/google_fonts.dart';

class OtherPage extends StatefulWidget {
  static const routeName = '/other_page';

  const OtherPage({Key? key}) : super(key: key);

  @override
  _OtherPageState createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  late User user;

  void _loadUser() {
    var currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      user = currentUser;
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
          'Lainnya',
          style: appBarStyle,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirestoreDatabase.getUser(user.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!.data()!['name'],
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                snapshot.data!.data()!['phoneNumber'],
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6D6D6D),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pushNamed(
                              context, ProfilePage.routeName,
                              arguments: user_model.User(
                                name: snapshot.data!.data()!['name'],
                                phoneNumber:
                                    snapshot.data!.data()!['phoneNumber'],
                                address: snapshot.data!.data()!['address'],
                              )).then((_) {
                            setState(() {});
                          }),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: Color(0xFF248CCE),
                              borderRadius: BorderRadius.circular(19),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              'Ubah Profile',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 20, bottom: 20),
                        child: Text(
                          'Pusat Bantuan & Informasi',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            listSetting(
                              text: 'Pengingat Otomatis',
                              icon: Icons.access_alarm,
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AlarmPage.routeName);
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            // listSetting(
                            //   text: 'Bagikan Buku Maggot',
                            //   icon: Icons.share,
                            //   onTap: () {},
                            // ),
                            const SizedBox(
                              height: 5,
                            ),
                            listSetting(
                              text: 'Pusat Bantuan',
                              icon: Icons.info_outline,
                              onTap: () {},
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            // listSetting(
                            //   text: 'Beri Nilai Buku Maggot',
                            //   icon: Icons.star_border_rounded,
                            //   onTap: () {},
                            // ),
                            listSetting(
                              text: 'Keluar',
                              icon: Icons.exit_to_app_rounded,
                              color: Colors.red,
                              onTap: () {
                                CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.confirm,
                                    confirmBtnText: 'Keluar',
                                    cancelBtnText: 'Batal',
                                    title: 'Apakah anda ingin keluar?',
                                    onConfirmBtnTap: () async {
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.pushReplacementNamed(
                                          context, LoginPage.routeName);
                                    });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }

  ListTile listSetting({
    required String text,
    required IconData icon,
    required Function() onTap,
    Color color = Colors.black,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
        color: color,
      ),
      title: Text(
        text,
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
      ),
      dense: true,
      enabled: true,
      selected: false,
      onTap: onTap,
    );
  }
}

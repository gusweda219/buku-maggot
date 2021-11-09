import 'package:buku_maggot_app/ui/profie_page.dart';
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          title: Text('Lainnya'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Budi',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            '+62855555555',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6D6D6D),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        Navigator.pushNamed(context, ProfilePage.routeName),
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFF248CCE),
                        borderRadius: BorderRadius.circular(19),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        'Ubah Profile',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
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
                        SizedBox(
                          height: 5,
                        ),
                        ListSettings(
                          text: 'Pengingat Otomatis',
                          icon: Icons.access_alarm,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ListSettings(
                          text: 'Bagikan Buku Maggot',
                          icon: Icons.share,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ListSettings(
                          text: 'Pusat Bantuan',
                          icon: Icons.info_outline,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ListSettings(
                          text: 'Beri Nilai Buku Maggot',
                          icon: Icons.star_border_rounded,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 100,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 70),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.red,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      height: 64,
                      padding: EdgeInsets.only(top: 23),
                      child: Text(
                        'KELUAR',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListTile ListSettings({
    required String text,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
        color: Colors.black,
      ),
      title: Text(
        text,
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      dense: true,
      enabled: true,
      selected: false,
      onTap: () {
        print('coba');
      },
    );
  }
}

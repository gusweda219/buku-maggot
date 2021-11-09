import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:buku_maggot_app/common/styles.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile_page';

  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  String hasil = "hasil input";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          title: Text('Ubah Profile'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Nama',
                          labelStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        controller: nameController,
                        onChanged: (value) {
                          print('Exchange');
                        },
                        autocorrect: false,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Alamat',
                          labelStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        controller: addressController,
                        autocorrect: false,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                      IntlPhoneField(
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                        ),
                        initialCountryCode: 'ID',
                        initialValue: '12',
                        onChanged: (phone) {
                          print(phone.completeNumber);
                        },
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.error_outline_rounded,
                            size: 50,
                            color: Colors.orange[300],
                          ),
                          title: Text(
                            'Perhatian!  Nomor yang terdaftar di aplikasi tidak dapat diubah. Ini adalah nomor Telepon untuk masuk ke aplikasi Buku Maggot',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 210, bottom: 20),
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              'SIMPAN',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.black,
                              primary: primaryColor,
                              shape: StadiumBorder(),
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
      ),
    );
  }
}

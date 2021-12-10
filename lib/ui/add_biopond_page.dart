import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/utils/firestore_database.dart';
import 'package:buku_maggot_app/utils/model/biopond.dart';
import 'package:buku_maggot_app/widgets/input_fieldbiopond.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AddBiopondPage extends StatefulWidget {
  static const routeName = '/add_biopond_page';
  const AddBiopondPage({Key? key}) : super(key: key);

  @override
  _AddBiopondPageState createState() => _AddBiopondPageState();
}

class _AddBiopondPageState extends State<AddBiopondPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();

  late User _user;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text('Tambah Biopond', style: appBarStyle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 8),
                  child: Input_Field(
                    textlabel: 'Nama Biopond',
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    text: 'Nama tidak boleh kosong',
                  ),
                ),
                // Input_Field(
                //   textlabel: 'Panjang',
                //   controller: _lengthController,
                //   keyboardType: TextInputType.number,
                //   text: 'Panjang',

                // ),
                Text(
                  'Ukuran Biopond',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextFormField(
                    controller: _lengthController,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Panjang',
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      fillColor: const Color(0xFFF3F4F8),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r"^([0-9]+\.?[0-9]*|\.[0-9]+)"))
                    ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Panjang tidak boleh kosong';
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextFormField(
                    controller: _widthController,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Lebar',
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      fillColor: const Color(0xFFF3F4F8),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r"^([0-9]+\.?[0-9]*|\.[0-9]+)"))
                    ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lebar tidak boleh kosong';
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextFormField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Tinggi',
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      fillColor: const Color(0xFFF3F4F8),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r"^([0-9]+\.?[0-9]*|\.[0-9]+)"))
                    ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Tinggi tidak boleh kosong';
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 100,
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      final isValid = _formKey.currentState!.validate();

                      if (isValid) {
                        _formKey.currentState!.save();
                        try {
                          await FirestoreDatabase.addBiopond(
                              _user.uid,
                              Biopond(
                                name: _nameController.text,
                                length: double.parse(_lengthController.text),
                                width: double.parse(_widthController.text),
                                height: double.parse(_heightController.text),
                                timestamp: Timestamp.fromMicrosecondsSinceEpoch(
                                    DateTime.now().microsecondsSinceEpoch),
                              ));
                          print('success add');
                          Navigator.pop(context);
                        } catch (e) {
                          print(e);
                        }
                      }
                    },
                    child: Text(
                      'Simpan',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }
}

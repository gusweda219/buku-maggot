import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/utils/firestore_database.dart';
import 'package:buku_maggot_app/utils/model/biopond.dart';
import 'package:buku_maggot_app/widgets/input_field.dart';
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

  bool _numberIsValid(String value) {
    value.replaceAll(',', '.');
    try {
      double.parse(value);
      return true;
    } catch (e) {
      return false;
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputField(
                  textlabel: 'Nama Biopond',
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Nama biopond tidak boleh kosong";
                    }
                  },
                ),
                const SizedBox(
                  height: 14,
                ),
                Text(
                  'Ukuran Biopond',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                InputField(
                  textlabel: 'Panjang',
                  controller: _lengthController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Panjang tidak boleh kosong";
                    } else if (!_numberIsValid(value)) {
                      return "Panjang tidak valid";
                    } else if (double.parse(value) <= 0) {
                      return "Panjang harus lebih dari 0";
                    }
                  },
                ),
                const SizedBox(
                  height: 14,
                ),
                InputField(
                  textlabel: 'Lebar',
                  controller: _widthController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Lebar tidak boleh kosong";
                    } else if (!_numberIsValid(value)) {
                      return "Lebar tidak valid";
                    } else if (double.parse(value) <= 0) {
                      return "Lebar harus lebih dari 0";
                    }
                  },
                ),
                const SizedBox(
                  height: 14,
                ),
                InputField(
                  textlabel: 'Tinggi',
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Tinggi tidak boleh kosong";
                    } else if (!_numberIsValid(value)) {
                      return "Tinggi tidak valid";
                    } else if (double.parse(value) <= 0) {
                      return "Tinggi harus lebih dari 0";
                    }
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
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
                                name: _nameController.text.trim(),
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

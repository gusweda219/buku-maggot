import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/utils/firestore_database.dart';
import 'package:buku_maggot_app/utils/model/biopond.dart';
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
        title: const Text('Tambah Biopond'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
            ),
            TextFormField(
              controller: _lengthController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r"^([0-9]+\.?[0-9]*|\.[0-9]+)"))
              ],
            ),
            TextFormField(
              controller: _widthController,
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _heightController,
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
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
          ],
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

import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/utils/firestore_database.dart';
import 'package:buku_maggot_app/utils/model/user.dart' as user_model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalFormPage extends StatefulWidget {
  static const routeName = '/form_personal_page';
  const PersonalFormPage({Key? key}) : super(key: key);

  @override
  State<PersonalFormPage> createState() => _PersonalFormPageState();
}

class _PersonalFormPageState extends State<PersonalFormPage> {
  final formKey = GlobalKey<FormState>();
  late User user;

  String name = '';
  String address = '';

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  void _loadUser() {
    var currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      user = currentUser;
    }
  }

  Widget buildName() => TextFormField(
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.person_outline,
            color: Color(
              0xFF8C8FA5,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Nama tidak boleh kosong';
          }
        },
        keyboardType: TextInputType.name,
        onSaved: (value) {
          name = value!;
        },
      );

  Widget buildAddress() => TextFormField(
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.location_on_outlined,
            color: Color(
              0xFF8C8FA5,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Alamat tidak boleh kosong';
          }
        },
        keyboardType: TextInputType.streetAddress,
        onSaved: (value) {
          address = value!;
        },
      );

  Widget buildSubmit() => Builder(
        builder: (context) => SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              final isValid = formKey.currentState!.validate();

              if (isValid) {
                formKey.currentState!.save();
                try {
                  await FirestoreDatabase.addUser(
                      user.uid,
                      user_model.User(
                        name: name,
                        phoneNumber: user.phoneNumber!,
                        address: address,
                      ));
                  print('success add');
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
                  fontWeight: FontWeight.w500,
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
      );

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
        title: Text('Data Diri'),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 13),
          children: [
            Text(
              'Isi form di bawah ini dengan data diri anda',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Nama',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF172331),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            buildName(),
            SizedBox(
              height: 16,
            ),
            Text(
              'Alamat',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF172331),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            buildAddress(),
            SizedBox(
              height: 30,
            ),
            buildSubmit(),
          ],
        ),
      ),
    );
  }
}

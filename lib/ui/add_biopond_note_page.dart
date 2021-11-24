import 'package:buku_maggot_app/utils/firestore_database.dart';
import 'package:buku_maggot_app/utils/model/note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddBiopondNotePage extends StatefulWidget {
  static const routeName = '/add_biopond_note_page';
  final Map<String, String> dataId;
  const AddBiopondNotePage({Key? key, required this.dataId}) : super(key: key);

  @override
  _AddBiopondNotePageState createState() => _AddBiopondNotePageState();
}

class _AddBiopondNotePageState extends State<AddBiopondNotePage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _seedsController = TextEditingController();
  final _materialTypeController = TextEditingController();
  final _materialWeightController = TextEditingController();
  final _maggotController = TextEditingController();
  final _kasgotController = TextEditingController();

  late User _user;

  late DateTime _dateTime;

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
    _dateTime = DateTime.now();
    _dateController.text = DateFormat.yMMMMd('id').format(_dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _dateController,
              onTap: () async {
                var date = await showDatePicker(
                  context: context,
                  locale: const Locale('id'),
                  initialDate: _dateTime,
                  firstDate: DateTime(2021),
                  lastDate: DateTime(2045),
                );

                if (date != null) {
                  _dateTime = date;
                  _dateController.text =
                      DateFormat.yMMMMd('id').format(_dateTime);
                }
              },
              readOnly: true,
            ),
            TextFormField(
              controller: _seedsController,
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _materialTypeController,
            ),
            TextFormField(
              controller: _materialWeightController,
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _maggotController,
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _kasgotController,
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                final isValid = _formKey.currentState!.validate();

                if (isValid) {
                  _formKey.currentState!.save();
                  try {
                    await FirestoreDatabase.addBiopondNote(
                        _user.uid,
                        widget.dataId['bid']!,
                        widget.dataId['cid']!,
                        Note(
                          timestamp: Timestamp.fromMicrosecondsSinceEpoch(
                              _dateTime.microsecondsSinceEpoch),
                          seeds: double.parse(_seedsController.text),
                          materialType: _materialTypeController.text,
                          materialWeight:
                              double.parse(_materialWeightController.text),
                          maggot: double.parse(_maggotController.text),
                          kasgot: double.parse(_kasgotController.text),
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
    _dateController.dispose();
    _seedsController.dispose();
    _materialTypeController.dispose();
    _materialWeightController.dispose();
    _maggotController.dispose();
    _kasgotController.dispose();
    super.dispose();
  }
}

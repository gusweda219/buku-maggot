import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/utils/firestore_database.dart';
import 'package:buku_maggot_app/utils/model/note.dart';
import 'package:buku_maggot_app/widgets/input_fieldbiopond.dart';
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

  String tWeightMaterial = 'kg';
  String tWeightMaggot = 'kg';
  String tWeightKasgot = 'kg';

  late User _user;

  late DateTime _dateTime;

  void _loadUser() {
    var currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      _user = currentUser;
    }
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("kg"), value: "kg"),
      DropdownMenuItem(child: Text("g"), value: "g"),
    ];
    return menuItems;
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
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text('Tambah Catatan Biopond', style: appBarStyle),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(10),
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
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.date_range_rounded,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              readOnly: true,
            ),
            SizedBox(
              height: 10,
            ),
            Input_Field(
              textlabel: 'Bibit',
              controller: _seedsController,
              keyboardType: TextInputType.name,
              text: 'Bibit tidak boleh kosong',
            ),
            SizedBox(
              height: 14,
            ),
            Input_Field(
              textlabel: 'Jenis Bahan Baku',
              controller: _materialTypeController,
              keyboardType: TextInputType.name,
              text: 'Jenis bahan baku tidak boleh kosong',
            ),
            SizedBox(
              height: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Input_Field(
                    textlabel: 'Berat Bahan Baku',
                    controller: _materialWeightController,
                    keyboardType: TextInputType.number,
                    text: 'Berat bahan baku tidak boleh kosong',
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade700,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: tWeightMaterial,
                      onChanged: (String? newValue) {
                        setState(() {
                          tWeightMaterial = newValue!;
                        });
                      },
                      items: dropdownItems,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Input_Field(
                    textlabel: 'Berat Maggot',
                    controller: _maggotController,
                    keyboardType: TextInputType.number,
                    text: 'Berat maggot tidak boleh kosong',
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade700,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: tWeightMaggot,
                      onChanged: (String? newValue) {
                        setState(() {
                          tWeightMaggot = newValue!;
                        });
                      },
                      items: dropdownItems,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Input_Field(
                    textlabel: 'Berat Kasgot',
                    controller: _kasgotController,
                    keyboardType: TextInputType.number,
                    text: 'Berat kasgot tidak boleh kosong',
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade700,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: tWeightKasgot,
                      onChanged: (String? newValue) {
                        setState(
                          () {
                            tWeightKasgot = newValue!;
                          },
                        );
                      },
                      items: dropdownItems,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: ElevatedButton(
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

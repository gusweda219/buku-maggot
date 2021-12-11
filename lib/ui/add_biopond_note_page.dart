import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/utils/firestore_database.dart';
import 'package:buku_maggot_app/utils/model/note.dart';
import 'package:buku_maggot_app/widgets/input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
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

  String tSeeds = 'kg';
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
      const DropdownMenuItem(child: Text("kg"), value: "kg"),
      const DropdownMenuItem(child: Text("g"), value: "g"),
    ];
    return menuItems;
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
              height: 14,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InputField(
                    textlabel: 'Bibit',
                    controller: _seedsController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      } else if (!_numberIsValid(value)) {
                        return "Bibit tidak valid";
                      } else if (double.parse(value) <= 0) {
                        return "Bibit harus lebih dari 0";
                      }
                    },
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
                      value: tSeeds,
                      onChanged: (String? newValue) {
                        setState(() {
                          tSeeds = newValue!;
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
            InputField(
              textlabel: 'Jenis Bahan Baku',
              controller: _materialTypeController,
              keyboardType: TextInputType.name,
              validator: (value) {
                if (_materialWeightController.text.isNotEmpty &&
                    value!.isEmpty) {
                  return 'Jenis bahan baku tidak boleh kosong';
                }
              },
            ),
            SizedBox(
              height: 14,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InputField(
                    textlabel: 'Berat Bahan Baku',
                    controller: _materialWeightController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      } else if (!_numberIsValid(value)) {
                        return "Berat bahan baku tidak valid";
                      } else if (double.parse(value) <= 0) {
                        return "Berat bahan baku harus lebih dari 0";
                      }
                    },
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
            Text(
              'Hasil Panen',
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InputField(
                    textlabel: 'Berat Maggot',
                    controller: _maggotController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      } else if (!_numberIsValid(value)) {
                        return "Berat maggot tidak valid";
                      } else if (double.parse(value) <= 0) {
                        return "Berat maggot harus lebih dari 0";
                      }
                    },
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InputField(
                    textlabel: 'Berat Kasgot',
                    controller: _kasgotController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      } else if (!_numberIsValid(value)) {
                        return "Berat kasgot tidak valid";
                      } else if (double.parse(value) <= 0) {
                        return "Berat kasgot harus lebih dari 0";
                      }
                    },
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
            ElevatedButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                final isValid = _formKey.currentState!.validate();

                if (_seedsController.text.isEmpty &&
                    _materialTypeController.text.trim().isEmpty &&
                    _materialWeightController.text.isEmpty &&
                    _maggotController.text.isEmpty &&
                    _kasgotController.text.isEmpty) {
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.error,
                    title: 'Anda belum mengisi data!',
                  );
                } else if (isValid) {
                  _formKey.currentState!.save();
                  try {
                    await FirestoreDatabase.addBiopondNote(
                        _user.uid,
                        widget.dataId['bid']!,
                        widget.dataId['cid']!,
                        Note(
                          timestamp: Timestamp.fromMicrosecondsSinceEpoch(
                              _dateTime.microsecondsSinceEpoch),
                          seeds: _seedsController.text.isEmpty
                              ? 0
                              : tSeeds == 'kg'
                                  ? double.parse(_seedsController.text)
                                  : double.parse(_seedsController.text) / 1000,
                          materialType: _materialTypeController.text.trim(),
                          materialWeight: _materialWeightController.text.isEmpty
                              ? 0
                              : tWeightMaterial == 'kg'
                                  ? double.parse(_materialWeightController.text)
                                  : double.parse(
                                          _materialWeightController.text) /
                                      1000,
                          maggot: _maggotController.text.isEmpty
                              ? 0
                              : tWeightMaggot == 'kg'
                                  ? double.parse(_maggotController.text)
                                  : double.parse(_maggotController.text) / 1000,
                          kasgot: _kasgotController.text.isEmpty
                              ? 0
                              : tWeightKasgot == 'kg'
                                  ? double.parse(_kasgotController.text)
                                  : double.parse(_kasgotController.text) / 1000,
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

import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/utils/firestore_database.dart';
import 'package:buku_maggot_app/utils/model/biopond.dart';
import 'package:buku_maggot_app/widgets/input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class EditBiopondPage extends StatefulWidget {
  static const routeName = '/edit_biopond_page';
  final Biopond biopond;
  const EditBiopondPage({Key? key, required this.biopond}) : super(key: key);

  @override
  _EditBiopondPageState createState() => _EditBiopondPageState();
}

class _EditBiopondPageState extends State<EditBiopondPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();

  String tLength = 'm';
  String tWidth = 'm';
  String tHeight = 'm';

  late User _user;

  void _loadUser() {
    var currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      _user = currentUser;
    }
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("m"), value: "m"),
      const DropdownMenuItem(child: Text("cm"), value: "cm"),
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
    _nameController.text = widget.biopond.name;
    _lengthController.text = widget.biopond.length.toString();
    _widthController.text = widget.biopond.width.toString();
    _heightController.text = widget.biopond.height.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text('Edit Biopond', style: appBarStyle),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await FirestoreDatabase.deleteBiopond(
                    _user.uid, widget.biopond.id!);
                Navigator.pop(context);
              } catch (e) {
                print(e);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        ],
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
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InputField(
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
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade700,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: tLength,
                          onChanged: (String? newValue) {
                            setState(() {
                              tLength = newValue!;
                            });
                          },
                          items: dropdownItems,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InputField(
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
                    ),
                    const SizedBox(
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
                          value: tWidth,
                          onChanged: (String? newValue) {
                            setState(() {
                              tWidth = newValue!;
                            });
                          },
                          items: dropdownItems,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InputField(
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
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade700,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: tHeight,
                          onChanged: (String? newValue) {
                            setState(() {
                              tHeight = newValue!;
                            });
                          },
                          items: dropdownItems,
                        ),
                      ),
                    ),
                  ],
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
                          await FirestoreDatabase.updateBiopond(
                              _user.uid,
                              Biopond(
                                id: widget.biopond.id,
                                name: _nameController.text.trim(),
                                length: tLength == 'm'
                                    ? double.parse(_lengthController.text)
                                    : double.parse(_lengthController.text) /
                                        100,
                                width: tWidth == 'm'
                                    ? double.parse(_widthController.text)
                                    : double.parse(_widthController.text) / 100,
                                height: tHeight == 'm'
                                    ? double.parse(_heightController.text)
                                    : double.parse(_heightController.text) /
                                        100,
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

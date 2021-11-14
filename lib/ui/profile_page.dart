import 'package:buku_maggot_app/utils/firestore_database.dart';
import 'package:buku_maggot_app/utils/model/user.dart' as user_model;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:buku_maggot_app/common/styles.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile_page';
  final user_model.User user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late User user;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  // final TextEditingController numberController = TextEditingController();

  void _loadUser() {
    var currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      user = currentUser;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
    nameController.text = widget.user.name;
    addressController.text = widget.user.address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text('Ubah Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nama',
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                      },
                      keyboardType: TextInputType.name,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Alamat',
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      controller: addressController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Alamat tidak boleh kosong';
                        }
                      },
                      keyboardType: TextInputType.streetAddress,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                    // IntlPhoneField(
                    //   decoration: InputDecoration(
                    //     labelText: 'Phone Number',
                    //   ),
                    //   initialCountryCode: 'ID',
                    //   initialValue: '12',
                    //   onChanged: (phone) {
                    //     print(phone.completeNumber);
                    //   },
                    // ),
                    // Container(
                    //   padding: EdgeInsets.only(top: 10, bottom: 10),
                    //   margin: EdgeInsets.only(top: 10),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.all(
                    //       Radius.circular(10),
                    //     ),
                    //     color: Colors.white,
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.grey.withOpacity(0.8),
                    //         spreadRadius: 2,
                    //         blurRadius: 7,
                    //         offset: Offset(0, 4),
                    //       ),
                    //     ],
                    //   ),
                    //   child: ListTile(
                    //     leading: Icon(
                    //       Icons.error_outline_rounded,
                    //       size: 50,
                    //       color: Colors.orange[300],
                    //     ),
                    //     title: Text(
                    //       'Perhatian!  Nomor yang terdaftar di aplikasi tidak dapat diubah. Ini adalah nomor Telepon untuk masuk ke aplikasi Buku Maggot',
                    //       style: GoogleFonts.montserrat(
                    //         fontWeight: FontWeight.w400,
                    //         fontSize: 12,
                    //         color: Colors.black54,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  final isValid = _formKey.currentState!.validate();

                  if (isValid) {
                    _formKey.currentState!.save();
                    try {
                      await FirestoreDatabase.updateUser(
                          user.uid,
                          user_model.User(
                            name: nameController.text,
                            phoneNumber: widget.user.phoneNumber,
                            address: addressController.text,
                          ));
                      print('success update');
                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                    }
                  }
                },
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    super.dispose();
  }
}

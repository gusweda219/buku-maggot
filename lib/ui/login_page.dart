import 'package:buku_maggot_app/ui/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login_page';

  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

Future registerUser(String mobile, BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  await _auth.verifyPhoneNumber(
    phoneNumber: mobile,
    timeout: Duration(seconds: 30),
    verificationCompleted: (AuthCredential authCredential) async {
      print('verificationcomplete');
      await _auth
          .signInWithCredential(authCredential)
          .then((value) => Navigator.pushNamed(context, MainPage.routeName));
    },
    verificationFailed: (FirebaseAuthException e) {
      print('verificationfailed');
      print(e);
    },
    codeSent: (String verificationId, int? resendToken) {
      print('codesent');
      print(verificationId);
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      verificationId = verificationId;
      print(verificationId);
      print("Timeout");
    },
  );
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _mobilePhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'images/img_login.png',
                  width: 222,
                ),
                SizedBox(
                  height: 26,
                ),
                Text(
                  'Verifikasi OTP',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Kami akan mengirimkan OTP kepada anda di nomor ponsel ini',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Color(0xFF9C9898),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 38,
                ),
                Text(
                  'Masukkan Nomor Ponsel',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Color(0xFF9C9898),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _mobilePhoneController,
                    keyboardType: TextInputType.number,
                    textAlignVertical: TextAlignVertical.center,
                    style: GoogleFonts.montserrat(fontSize: 18),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '(+62)',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      prefixIconConstraints:
                          BoxConstraints(minWidth: 0, minHeight: 0),
                      suffixIcon: Icon(
                        Icons.verified,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      registerUser(
                          '+62${_mobilePhoneController.text}', context);
                    },
                    child: Text(
                      'Masuk',
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
}

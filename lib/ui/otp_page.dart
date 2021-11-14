import 'dart:async';

import 'package:buku_maggot_app/ui/main_page.dart';
import 'package:buku_maggot_app/ui/personal_form_page.dart';
import 'package:buku_maggot_app/utils/firestore_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPPage extends StatefulWidget {
  static const routeName = '/otp_page';
  final String number;

  const OTPPage({Key? key, required this.number}) : super(key: key);

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  String _verificationId = '';
  String _smsOtp = '';
  bool hasError = false;
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  void _verifyNumber(String number) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    await _auth.verifyPhoneNumber(
      phoneNumber: number,
      timeout: Duration(seconds: 30),
      verificationCompleted: (AuthCredential authCredential) async {
        print('verificationcomplete');
        await _auth.signInWithCredential(authCredential).then((value) async {
          if (value.user != null) {
            print('user logged in');
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print('verificationfailed');
        print(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        print('codesent');
        print(verificationId);
        print(resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
        print("Timeout");
        print(verificationId);
      },
    );
  }

  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
    _verifyNumber(widget.number);
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'images/img_otp.png',
                  width: 222,
                ),
                const SizedBox(
                  height: 26,
                ),
                Text(
                  'Verifikasi OTP',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Masukkan OTP yang telah dikirim ke ${widget.number}',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: const Color(0xFF9C9898),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 38,
                ),
                SizedBox(
                  width: 300,
                  child: PinCodeTextField(
                    appContext: context,
                    keyboardType: TextInputType.number,
                    length: 6,
                    showCursor: false,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    onCompleted: (v) {
                      print("Completed");
                    },
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        _smsOtp = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    hasError ? "*Silakan isi semua sel dengan benar" : "",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_smsOtp.length != 6) {
                        errorController!.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() => hasError = true);
                      } else {
                        setState(() {
                          hasError = false;
                        });
                        try {
                          await FirebaseAuth.instance
                              .signInWithCredential(
                                  PhoneAuthProvider.credential(
                                      verificationId: _verificationId,
                                      smsCode: _smsOtp))
                              .then((value) async {
                            if (value.user != null) {
                              final snapshot = await FirestoreDatabase.getUser(
                                  value.user!.uid);
                              if (snapshot.exists) {
                                Navigator.pushReplacementNamed(
                                    context, MainPage.routeName);
                              } else {
                                Navigator.pushReplacementNamed(
                                    context, PersonalFormPage.routeName);
                              }
                            }
                          });
                        } catch (e) {
                          print(e);
                          print('otp invalid');
                        }
                      }
                    },
                    child: Text(
                      'Proses',
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPPage extends StatefulWidget {
  static const routeName = '/otp_page';

  const OTPPage({Key? key}) : super(key: key);

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
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
                    child: PinFieldAutoFill(
                      codeLength: 6,
                      onCodeChanged: (val) {
                        print(val);
                      },
                    )),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
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

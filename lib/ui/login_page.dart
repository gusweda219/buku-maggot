import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/ui/register_page.dart';
import 'package:buku_maggot_app/widgets/input_field.dart';
import 'package:buku_maggot_app/widgets/password_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login_page';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 90, 15, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Masuk',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Selamat Datang',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 50,
                ),
                InputField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email_outlined,
                ),
                const SizedBox(
                  height: 10,
                ),
                PasswordField(
                  label: 'Password',
                  controller: _passwordController,
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Lupa password?',
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),
                  textAlign: TextAlign.end,
                ),
                const SizedBox(
                  height: 22,
                ),
                ElevatedButton(
                  onPressed: () {
                    print(_emailController.text);
                    print(_passwordController.text);
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
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tidak Punya Akun?',
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () =>
                          Navigator.pushNamed(context, RegisterPage.routeName),
                      child: Text(
                        'Daftar',
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

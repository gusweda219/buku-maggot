import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/ui/login_page.dart';
import 'package:buku_maggot_app/widgets/input_field.dart';
import 'package:buku_maggot_app/widgets/password_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = '/register_page';

  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 70, 15, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Daftar',
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
                  label: 'Nama',
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  icon: Icons.person_outline,
                ),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                  label: 'No HP',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  icon: Icons.phone_outlined,
                ),
                const SizedBox(
                  height: 10,
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
                  height: 22,
                ),
                ElevatedButton(
                  onPressed: () {
                    print(_emailController.text);
                    print(_passwordController.text);
                  },
                  child: Text(
                    'Daftar',
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
                      'Sudah Punya Akun?',
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
                          Navigator.pushNamed(context, LoginPage.routeName),
                      child: Text(
                        'Masuk',
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
}

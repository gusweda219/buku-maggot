import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/ui/login_page.dart';
import 'package:buku_maggot_app/ui/onboarding_page.dart';
import 'package:buku_maggot_app/ui/register_page.dart';
import 'package:buku_maggot_app/ui/splash_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      initialRoute: SplashPage.routeName,
      routes: {
        SplashPage.routeName: (context) => const SplashPage(),
        OnBoardingPage.routeName: (context) => const OnBoardingPage(),
        LoginPage.routeName: (context) => const LoginPage(),
        RegisterPage.routeName: (context) => const RegisterPage(),
      },
    );
  }
}

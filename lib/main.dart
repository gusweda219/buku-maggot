import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/ui/login_page.dart';
import 'package:buku_maggot_app/ui/main_page.dart';
import 'package:buku_maggot_app/ui/onboarding_page.dart';
import 'package:buku_maggot_app/ui/otp_page.dart';
import 'package:buku_maggot_app/ui/personal_form_page.dart';
import 'package:buku_maggot_app/ui/register_page.dart';
import 'package:buku_maggot_app/ui/splash_page.dart';
import 'package:buku_maggot_app/ui/transaction_form_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buku Maggot',
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('id'),
      ],
      initialRoute: SplashPage.routeName,
      routes: {
        SplashPage.routeName: (context) => const SplashPage(),
        OnBoardingPage.routeName: (context) => const OnBoardingPage(),
        LoginPage.routeName: (context) => const LoginPage(),
        OTPPage.routeName: (context) => OTPPage(
              number: ModalRoute.of(context)?.settings.arguments as String,
            ),
        PersonalFormPage.routeName: (context) => const PersonalFormPage(),
        RegisterPage.routeName: (context) => const RegisterPage(),
        MainPage.routeName: (context) => const MainPage(),
        TransactionFormPage.routeName: (context) => TransactionFormPage(
              typeForm: ModalRoute.of(context)?.settings.arguments as String,
            ),
      },
    );
  }
}

import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatelessWidget {
  static const routeName = '/onboarding_page';

  const OnBoardingPage({Key? key}) : super(key: key);

  Widget _buildImage(String imageName, [double width = 350]) {
    return Image.asset('images/$imageName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      imagePadding: EdgeInsets.zero,
      pageColor: Colors.white,
    );

    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'Solusi Mudah Untuk Farm Anda',
              body: '',
              image: _buildImage('onboarding1.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: 'Dapat Memudahkan Dalam Mencatat Transaksi',
              body: '',
              image: _buildImage('onboarding1.png'),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: 'Dapat Memudahkan Dalam Mencatat Hasil Ternak',
              body: '',
              image: _buildImage('onboarding1.png'),
              decoration: pageDecoration,
            ),
          ],
          next: const Icon(
            Icons.navigate_next_rounded,
            size: 30,
          ),
          skip: const Text('Lewati'),
          showSkipButton: true,
          done: const Text('Selesai'),
          onDone: () =>
              Navigator.pushReplacementNamed(context, LoginPage.routeName),
          color: primaryColor,
        ),
      ),
    );
  }
}

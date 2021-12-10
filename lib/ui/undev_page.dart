import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UnDevPage extends StatelessWidget {
  static const routeName = '/undev_page';

  const UnDevPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/img_undev.png',
            width: 300,
          ),
          Text(
            'Fitur ini segera hadir!',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Terimakasih telah menggunakan aplikasi ini. Fitur ini masih dalam tahap pengembangan.',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(),
            ),
          )
        ],
      ),
    );
  }
}

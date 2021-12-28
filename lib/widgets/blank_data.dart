import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlankData extends StatelessWidget {
  const BlankData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/blank_data.png',
              width: 300,
            ),
            Text(
              'Data Kosong!!',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 8, left: 16, right: 16, bottom: 16),
              child: Text(
                'Mohon maaf daftar datamu kosong',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

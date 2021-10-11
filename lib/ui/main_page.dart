import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/main_page';

  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _bottomNavIndex = 0;

  List<Widget> _listWidget = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _bottomNavIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF264653),
          unselectedItemColor: Colors.grey[600],
          iconSize: 30,
          selectedItemColor: Colors.white,
          selectedLabelStyle: GoogleFonts.montserrat(),
          unselectedLabelStyle: GoogleFonts.montserrat(),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.adb_rounded),
              label: 'Farmku',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_rounded),
              label: 'Transaksi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts_rounded),
              label: 'Lainnya',
            ),
          ],
          onTap: (selected) {
            setState(() {
              _bottomNavIndex = selected;
            });
          },
        ),
      ),
      extendBody: true,
    );
  }
}

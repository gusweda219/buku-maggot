// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/helper/background_service.dart';
import 'package:buku_maggot_app/helper/notification_helper.dart';
import 'package:buku_maggot_app/ui/add_alarm_page.dart';
import 'package:buku_maggot_app/ui/add_biopond_page.dart';
import 'package:buku_maggot_app/ui/add_biopond_note_page.dart';
import 'package:buku_maggot_app/ui/alarm_page.dart';
import 'package:buku_maggot_app/ui/biopond_detail_page.dart';
import 'package:buku_maggot_app/ui/edit_alarm_page.dart';
import 'package:buku_maggot_app/ui/edit_biopond_page.dart';
import 'package:buku_maggot_app/ui/edit_transaction_page.dart';
import 'package:buku_maggot_app/ui/login_page.dart';
import 'package:buku_maggot_app/ui/main_page.dart';
import 'package:buku_maggot_app/ui/onboarding_page.dart';
import 'package:buku_maggot_app/ui/other_page.dart';
import 'package:buku_maggot_app/ui/otp_page.dart';
import 'package:buku_maggot_app/ui/personal_form_page.dart';
import 'package:buku_maggot_app/ui/profile_page.dart';
import 'package:buku_maggot_app/ui/riwayat_biopond_detail_page.dart';
import 'package:buku_maggot_app/ui/riwayat_biopond_page.dart';
import 'package:buku_maggot_app/ui/splash_page.dart';
import 'package:buku_maggot_app/ui/transaction_form_page.dart';
import 'package:buku_maggot_app/ui/undev_page.dart';
import 'package:buku_maggot_app/utils/model/alarm.dart';
import 'package:buku_maggot_app/utils/model/biopond.dart';
import 'package:buku_maggot_app/utils/model/note.dart';
import 'package:buku_maggot_app/utils/model/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // final BackgroundService _service = BackgroundService();
  // _service.initializeIsolate();
  // AndroidAlarmManager.initialize();

  // final NotificationHelper _notificationHelper = NotificationHelper();
  // await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
        MainPage.routeName: (context) => const MainPage(),
        TransactionFormPage.routeName: (context) => TransactionFormPage(
              typeForm: ModalRoute.of(context)?.settings.arguments as String,
            ),
        ProfilePage.routeName: (context) => ProfilePage(
              user: ModalRoute.of(context)?.settings.arguments as User,
            ),
        OtherPage.routeName: (context) => const OtherPage(),
        AddBiopondPage.routeName: (context) => const AddBiopondPage(),
        BiopondDetailPage.routeName: (context) => BiopondDetailPage(
              bid: ModalRoute.of(context)?.settings.arguments as String,
            ),
        AddBiopondNotePage.routeName: (context) => AddBiopondNotePage(
              dataId: ModalRoute.of(context)?.settings.arguments
                  as Map<String, String>,
            ),
        RiwayatBiopondPage.routeName: (context) => RiwayatBiopondPage(
              bid: ModalRoute.of(context)?.settings.arguments as String,
            ),
        EditTransactionPage.routeName: (context) => EditTransactionPage(
              data: ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>,
            ),
        UnDevPage.routeName: (context) => const UnDevPage(),
        RiwayatBiopondDetailPage.routeName: (context) =>
            RiwayatBiopondDetailPage(
              notes: ModalRoute.of(context)?.settings.arguments as List<Note>,
            ),
        EditBiopondPage.routeName: (context) => EditBiopondPage(
            biopond: ModalRoute.of(context)?.settings.arguments as Biopond),
        AlarmPage.routeName: (context) => const AlarmPage(),
        AddAlarmPage.routeName: (context) => const AddAlarmPage(),
        EditAlarmPage.routeName: (context) => EditAlarmPage(
            alarm: ModalRoute.of(context)?.settings.arguments as Alarm),
      },
    );
  }
}

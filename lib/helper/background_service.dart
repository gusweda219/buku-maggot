// import 'dart:isolate';

// import 'dart:ui';

// import 'package:buku_maggot_app/helper/notification_helper.dart';
// import 'package:buku_maggot_app/main.dart';
// import 'package:buku_maggot_app/utils/model/alarm.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// final ReceivePort port = ReceivePort();

// class BackgroundService {
//   static BackgroundService? _instance;
//   static String _isolateName = 'isolate';
//   static SendPort? _uiSendPort;

//   BackgroundService._internal() {
//     _instance = this;
//   }

//   factory BackgroundService() => _instance ?? BackgroundService._internal();

//   void initializeIsolate() {
//     IsolateNameServer.registerPortWithName(
//       port.sendPort,
//       _isolateName,
//     );
//   }

//   static Future<void> callback(int i) async {
//     print('Alarm fired! $i');

//     final pref = await SharedPreferences.getInstance();
//     final NotificationHelper _notificationHelper = NotificationHelper();

//     var prefAlarm = pref.getString('alarm');

//     List<Alarm> alarms = [];
//     if (prefAlarm != null) {
//       alarms = Alarm.decode(prefAlarm);

//       alarms.removeWhere((element) => element.id == i);
//     }

//     var newPref = Alarm.encode(alarms);

//     pref.setString('alarm', newPref);

//     await _notificationHelper.showNotification(flutterLocalNotificationsPlugin);

//     _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
//     _uiSendPort?.send(null);
//   }

//   Future<void> someTask() async {
//     print('Updated data from the background isolate');
//   }
// }

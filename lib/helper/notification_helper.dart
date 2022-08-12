// import 'dart:math';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:rxdart/rxdart.dart';

// final selectNotificationSubject = BehaviorSubject<String>();

// class NotificationHelper {
//   static NotificationHelper? _instance;

//   NotificationHelper._internal() {
//     _instance = this;
//   }

//   factory NotificationHelper() => _instance ?? NotificationHelper._internal();

//   Future<void> initNotifications(
//       FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//     var initializationSettingsAndroid = AndroidInitializationSettings('logo');

//     var initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: (String? payload) async {
//       if (payload != null) {
//         print('notification payload: ' + payload);
//       }
//       selectNotificationSubject.add(payload ?? 'empty payload');
//     });
//   }

//   Future<void> showNotification(
//       FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//     var _channelId = "1";
//     var _channelName = "channel_01";
//     var _channelDescription = "restaurant channel";
//     var _index = Random().nextInt(20);

//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         _channelId, _channelName, _channelDescription,
//         importance: Importance.max,
//         priority: Priority.high,
//         ticker: 'ticker',
//         styleInformation: DefaultStyleInformation(true, true));

//     var platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     var titleNotification = "<b>Alarm</b>";
//     // var titleRestaurant = restaurant.restaurants[_index].name;
//     // print(titleRestaurant);

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       titleNotification,
//       'Alarm',
//       platformChannelSpecifics,
//       // payload: restaurant.restaurants[_index].id,
//     );
//   }

//   // void configureSelectNotificationSubject(String route) {
//   //   selectNotificationSubject.stream.listen((String payload) {
//   //     var restaurantId = payload;
//   //     Navigation.intentWithData(route, restaurantId);
//   //   });
//   // }
// }

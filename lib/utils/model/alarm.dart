import 'dart:convert';

class Alarm {
  Alarm(
      {required this.id,
      required this.description,
      required this.dateTime,
      required this.status});

  int id;
  String description;
  DateTime dateTime;
  bool status;

  factory Alarm.fromJson(Map<String, dynamic> jsonData) {
    return Alarm(
        id: jsonData['id'],
        description: jsonData['description'],
        dateTime: DateTime.parse(jsonData['dateTime']),
        status: jsonData['status']);
  }

  static Map<String, dynamic> toMap(Alarm alarm) => {
        'id': alarm.id,
        'description': alarm.description,
        'dateTime': alarm.dateTime.toString(),
        'status': alarm.status,
      };

  static String encode(List<Alarm> alarms) => json.encode(
      alarms.map<Map<String, dynamic>>((alarm) => Alarm.toMap(alarm)).toList());

  static List<Alarm> decode(String alarms) =>
      (json.decode(alarms) as List<dynamic>)
          .map<Alarm>((item) => Alarm.fromJson(item))
          .toList();
}

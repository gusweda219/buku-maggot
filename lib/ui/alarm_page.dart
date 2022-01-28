import 'dart:convert';

import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/ui/add_alarm_page.dart';
import 'package:buku_maggot_app/ui/edit_alarm_page.dart';
import 'package:buku_maggot_app/utils/model/alarm.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmPage extends StatefulWidget {
  static const routeName = '/alarm_page';
  const AlarmPage({Key? key}) : super(key: key);

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  List<Alarm> alarm = [];

  @override
  void initState() {
    super.initState();
    loadAlarm();
  }

  void loadAlarm() async {
    final pref = await SharedPreferences.getInstance();
    var data = pref.getString('alarm');
    setState(() {
      if (data != null) {
        alarm = Alarm.decode(data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text("Pengingat Otomatis"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: alarm.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, EditAlarmPage.routeName,
                      arguments: alarm[index])
                  .then((_) {
                loadAlarm();
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ]),
              child: ListTile(
                title: Text(alarm[index].description),
                subtitle: Text(
                  DateFormat.yMMMMd('id')
                      .add_jm()
                      .format(alarm[index].dateTime),
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500, color: Colors.grey[600]),
                ),
                trailing: Switch(
                    value: alarm[index].status,
                    onChanged: (value) async {
                      final pref = await SharedPreferences.getInstance();

                      setState(() {
                        alarm[index].status = value;
                        pref.setString('alarm', Alarm.encode(alarm));
                      });
                    }),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddAlarmPage.routeName).then((_) {
            loadAlarm();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/utils/model/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EditAlarmPage extends StatefulWidget {
  static const routeName = "/edit_alarm_page";
  final Alarm alarm;
  const EditAlarmPage({Key? key, required this.alarm}) : super(key: key);

  @override
  State<EditAlarmPage> createState() => _EditAlarmPageState();
}

class _EditAlarmPageState extends State<EditAlarmPage> {
  late DateTime _dateTime;
  final _descController = TextEditingController();
  late DateTime _pickTime;

  @override
  void initState() {
    super.initState();
    _dateTime = widget.alarm.dateTime;
    _pickTime = widget.alarm.dateTime;
    _descController.text = widget.alarm.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text("Edit Pengingat Otomatis"),
        actions: [
          IconButton(
            onPressed: () async {
              final pref = await SharedPreferences.getInstance();
              var prefAlarm = pref.getString('alarm');

              List<Alarm> alarms = [];
              if (prefAlarm != null) {
                alarms = Alarm.decode(prefAlarm);

                alarms.removeWhere((element) => element.id == widget.alarm.id);
              }

              var newPref = Alarm.encode(alarms);

              pref.setString('alarm', newPref);

              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: TimePickerSpinner(
              time: _dateTime,
              isForce2Digits: true,
              onTimeChange: (value) {
                _pickTime = value;
              },
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat.yMMMMd('id').format(_dateTime)),
                        IconButton(
                            onPressed: () async {
                              var date = await showDatePicker(
                                context: context,
                                locale: const Locale('id'),
                                initialDate: _dateTime,
                                firstDate: DateTime(2021),
                                lastDate: DateTime(2045),
                              );

                              setState(() {
                                if (date != null) {
                                  _dateTime = date;
                                }
                              });
                            },
                            icon: Icon(Icons.calendar_today_rounded)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Deskripsi',
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      controller: _descController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final pref = await SharedPreferences.getInstance();
                        var prefAlarm = pref.getString('alarm');

                        List<Alarm> alarms = [];
                        if (prefAlarm != null) {
                          alarms = Alarm.decode(prefAlarm);

                          var alarm = alarms.where(
                              (element) => element.id == widget.alarm.id);

                          alarm.first.dateTime = DateTime(
                              _dateTime.year,
                              _dateTime.month,
                              _dateTime.day,
                              _pickTime.hour,
                              _pickTime.minute);

                          alarm.first.description = _descController.text;
                        }

                        var newPref = Alarm.encode(alarms);

                        pref.setString('alarm', newPref);

                        Navigator.pop(context);
                      },
                      child: Text(
                        'Simpan',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }
}

// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:buku_maggot_app/common/styles.dart';
import 'package:buku_maggot_app/helper/background_service.dart';
import 'package:buku_maggot_app/utils/model/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddAlarmPage extends StatefulWidget {
  static const routeName = "/add_alarm_page";
  const AddAlarmPage({Key? key}) : super(key: key);

  @override
  State<AddAlarmPage> createState() => _AddAlarmPageState();
}

class _AddAlarmPageState extends State<AddAlarmPage> {
  var _dateTime = DateTime.now();
  final _descController = TextEditingController();
  var _pickTime = DateTime.now();
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text("Tambah Pengingat Otomatis"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TimePickerSpinner(
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
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
                            }

                            if (alarms.length == 20) {
                              setState(() {
                                visible = true;
                              });
                            } else {
                              int id = 1;
                              for (var i = 1; i <= 20; i++) {
                                if ((alarms.where((element) => element.id == i))
                                    .isEmpty) {
                                  id = i;
                                  break;
                                }
                              }

                              var dt = DateTime(
                                  _dateTime.year,
                                  _dateTime.month,
                                  _dateTime.day,
                                  _pickTime.hour,
                                  _pickTime.minute);

                              alarms.add(Alarm(
                                  id: id,
                                  description: _descController.text,
                                  dateTime: dt,
                                  status: true));

                              var newPref = Alarm.encode(alarms);

                              pref.setString('alarm', newPref);

                              // await AndroidAlarmManager.oneShotAt(
                              //   dt,
                              //   id,
                              //   BackgroundService.callback,
                              //   exact: true,
                              //   wakeup: true,
                              // );

                              Navigator.pop(context);
                            }
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
          Visibility(
            visible: visible,
            child: Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                color: Colors.red,
                child: Center(
                    child: Text('Jumlah alarm maksimal 20',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ))),
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

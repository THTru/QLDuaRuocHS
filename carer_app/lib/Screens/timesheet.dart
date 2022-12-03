import 'dart:convert';
// import 'dart:io';

import 'package:carer_app/Screens/trip.dart';
import 'package:flutter/material.dart';
import 'package:carer_app/rounded_button.dart';
import 'package:carer_app/General/general.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:carer_app/Screens/trip.dart';

class TimeSheetScreen extends StatefulWidget {
  const TimeSheetScreen({Key? key}) : super(key: key);

  @override
  _TimeSheetScreenState createState() => _TimeSheetScreenState();
}

class _TimeSheetScreenState extends State<TimeSheetScreen> {
  final storage = new FlutterSecureStorage();
  DateTime _chosenDate = DateTime.now();
  List<dynamic> _triplist = [];
  bool _error = false;
  bool _loading = true;

  loadTripList() async {
    setState(() {
      _triplist = [];
      _loading = true;
    });

    var user = await storage.read(key: 'user');
    if (user != null) {
      final params = '?date=' +
          yMD(_chosenDate.toString()) +
          '&carer_id=' +
          jsonDecode(user)['id'].toString() +
          '&driver_id=-1&vehicle_id=-1&line_id=-1&finish=-1';
      await http
          .get(Uri.parse(baseURL() + '/api/trips/filter' + params.toString()))
          .then((response) {
        if (response.statusCode == 200) {
          setState(() {
            final jsonData = jsonDecode(response.body);
            _triplist = jsonData;
          });
        } else {
          setState(() {
            _error;
          });
        }
      }).catchError((onError) {
        setState(() {
          _error = true;
        });
      });
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTripList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Lịch làm việc',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MaterialButton(
                color: Colors.blueAccent,
                textColor: Colors.white,
                child: Wrap(children: [
                  Icon(Icons.calendar_month_outlined),
                  Text(
                    ' ' + dMY(_chosenDate.toString()),
                    style: TextStyle(fontSize: 20),
                  )
                ]),
                onPressed: () async {
                  var chosenDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2015, 1, 1),
                      lastDate: DateTime(2025, 12, 31));
                  if (chosenDate != null)
                    setState(() {
                      _chosenDate = chosenDate;
                      loadTripList();
                    });
                },
              ),
              _error == true
                  ? Center(
                      child: Text(
                      'Có lỗi tải dữ liệu',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ))
                  : _loading == true
                      ? Center(child: CircularProgressIndicator())
                      : Expanded(
                          child: ListView.builder(
                              padding: EdgeInsets.all(8),
                              itemCount: _triplist.length,
                              itemBuilder: (context, index) {
                                return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(_triplist[index]['trip_name'],
                                                style: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                'Giờ dự kiến: ' +
                                                    _triplist[index]['line']
                                                                ['linetype']
                                                            ['time_start']
                                                        .toString(),
                                                style: TextStyle(fontSize: 19)),
                                            Text(
                                                'Bắt đầu: ' +
                                                    _triplist[index]['start_at']
                                                        .toString(),
                                                style: TextStyle(fontSize: 19)),
                                            Text(
                                                'Kết thúc: ' +
                                                    _triplist[index]['end_at']
                                                        .toString(),
                                                style: TextStyle(fontSize: 19)),
                                            MaterialButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TripScreen(
                                                              tripID: _triplist[
                                                                      index]
                                                                  ['trip_id'])),
                                                ).then((value) => setState(() {
                                                      loadTripList();
                                                    }));
                                              },
                                              textColor: Colors.white,
                                              child: Wrap(children: [
                                                Icon(Icons.info_outline),
                                                Text(' Chi tiết',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 19))
                                              ]),
                                              color: Colors.blueAccent,
                                            )
                                          ],
                                        )));
                              }))
              /*FractionallySizedBox(
                  widthFactor: 1,
                  child: Card(
                      margin: EdgeInsets.all(5.0),
                      color: Colors.orangeAccent,
                      child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Wrap(
                            children: [
                              Icon(Icons.list, color: Colors.white),
                              Text(' Đăng ký tuyến xe cho con',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 22))
                            ],
                          ))))*/
            ],
          )),
    );
  }
}

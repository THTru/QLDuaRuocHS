import 'dart:convert';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parent_app/rounded_button.dart';
import 'package:parent_app/General/general.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:parent_app/Screens/map.dart';

class TimeSheetScreen extends StatefulWidget {
  const TimeSheetScreen({Key? key}) : super(key: key);

  @override
  _TimeSheetScreenState createState() => _TimeSheetScreenState();
}

class _TimeSheetScreenState extends State<TimeSheetScreen> {
  final storage = new FlutterSecureStorage();
  DateTime _chosenDate = DateTime.now();
  List<dynamic> _studenttriplist = [];
  bool _error = false;
  bool _loading = true;

  String _student_name = '';

  loadStudentTripList() async {
    setState(() {
      _studenttriplist = [];
      _loading = true;
    });

    var student = await storage.read(key: 'student');
    if (student != null) {
      setState(() {
        _student_name = jsonDecode(student)['student_name'];
      });
      final params = '?date=' +
          yMD(_chosenDate.toString()) +
          '&student_id=' +
          jsonDecode(student)['student_id'].toString();
      await http
          .get(Uri.parse(
              baseURL() + '/api/studenttrips/date' + params.toString()))
          .then((response) {
        if (response.statusCode == 200) {
          setState(() {
            final jsonData = jsonDecode(response.body);
            _studenttriplist = jsonData;
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

  requestAbsence(studenttripID) async {
    final storage = new FlutterSecureStorage();
    var user = await storage.read(key: 'user');

    if (user != null) {
      final params = {
        'studenttrip_id': studenttripID.toString(),
        'parent_id': jsonDecode(user)['id'].toString(),
      };
      await http
          .patch(Uri.parse(baseURL() + '/api/requestAbsence'), body: params)
          .then((response) {
        if (response.statusCode == 200) {
          successSnackBar(context, 'Xin phép nghỉ thành công');
          loadStudentTripList();
        } else if (response.statusCode == 430) {
          errorSnackBar(context, jsonDecode(response.body).values.first);
        } else {
          errorSnackBar(context, 'Lỗi Server');
        }
      }).catchError((error) {
        errorSnackBar(context, 'Lỗi Server');
      });
    } else {
      errorSnackBar(context, 'Không thể thực hiện');
    }
  }

  @override
  void initState() {
    super.initState();
    loadStudentTripList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Lịch trình của bé',
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
              Text('Bé: ' + _student_name.toString(),
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold)),
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
                      loadStudentTripList();
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
                              itemCount: _studenttriplist.length,
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
                                            Text(
                                                _studenttriplist[index]['trip']
                                                    ['trip_name'],
                                                style: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                'Xe: ' +
                                                    _studenttriplist[index]
                                                                    ['trip']
                                                                ['vehicle']
                                                            ['vehicle_no']
                                                        .toString(),
                                                style: TextStyle(
                                                  fontSize: 19,
                                                )),
                                            Text(
                                                'Bảo mẫu: ' +
                                                    _studenttriplist[index]
                                                                ['trip']
                                                            ['carer']['name']
                                                        .toString() +
                                                    ' - SĐT: ' +
                                                    _studenttriplist[index]
                                                            ['trip']['carer']
                                                        ['phone'],
                                                style: TextStyle(
                                                  fontSize: 19,
                                                )),
                                            Text(
                                                'Tài xế: ' +
                                                    _studenttriplist[index]
                                                                    ['trip']
                                                                ['driver']
                                                            ['driver_name']
                                                        .toString() +
                                                    ' - SĐT: ' +
                                                    _studenttriplist[index]
                                                            ['trip']['driver']
                                                        ['driver_phone'],
                                                style: TextStyle(
                                                  fontSize: 19,
                                                )),
                                            Text(
                                                'Giờ đón dự kiến: ' +
                                                    _studenttriplist[index]
                                                            ['est_time']
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 19,
                                                    color: Colors.blueAccent)),
                                            Text(
                                                'Lên xe: ' +
                                                    _studenttriplist[index]
                                                            ['on_at']
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 19,
                                                    color: Colors.green)),
                                            Text(
                                                'Xuống xe: ' +
                                                    _studenttriplist[index]
                                                            ['off_at']
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 19,
                                                    color:
                                                        Colors.orangeAccent)),
                                            Wrap(children: [
                                              _studenttriplist[index]
                                                          ['absence_req'] ==
                                                      1
                                                  ? Text('Đã xin phép nghỉ',
                                                      style: TextStyle(
                                                          fontSize: 19,
                                                          color: Colors
                                                              .pinkAccent))
                                                  : MaterialButton(
                                                      onPressed: () {
                                                        requestAbsence(
                                                            _studenttriplist[
                                                                    index][
                                                                'studenttrip_id']);
                                                      },
                                                      textColor: Colors.white,
                                                      child: Wrap(children: [
                                                        Icon(Icons
                                                            .no_backpack_outlined),
                                                        Text(' Xin nghỉ',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 19))
                                                      ]),
                                                      color: Colors.pinkAccent,
                                                    ),
                                              _studenttriplist[index]
                                                          ['absence'] ==
                                                      1
                                                  ? Text(
                                                      ' (Đã xác nhận nghỉ)',
                                                      style: TextStyle(
                                                          fontSize: 19,
                                                          color:
                                                              Colors.blueGrey))
                                                  : Text(''),
                                            ]),
                                            MaterialButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MapScreen(
                                                              stop: jsonEncode(
                                                                  _studenttriplist[
                                                                          index]
                                                                      [
                                                                      'stop']))),
                                                );
                                              },
                                              textColor: Colors.white,
                                              child: Wrap(children: [
                                                Icon(Icons.map_outlined),
                                                Text(' Xem điểm đón',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 19))
                                              ]),
                                              color: Colors.blueAccent,
                                            ),
                                          ],
                                        )));
                              }))
            ],
          )),
    );
  }
}

import 'dart:convert';
// import 'dart:io';

import 'package:carer_app/Screens/map.dart';
import 'package:flutter/material.dart';
import 'package:carer_app/rounded_button.dart';
import 'package:carer_app/General/general.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:carer_app/Screens/map.dart';

// import 'package:carer_app/Screens/reginfo.dart';

class StudentTripListScreen extends StatefulWidget {
  var tripID;
  StudentTripListScreen({Key? key, @required this.tripID}) : super(key: key);

  @override
  _StudentTripListScreenState createState() =>
      _StudentTripListScreenState(tripID);
}

class _StudentTripListScreenState extends State<StudentTripListScreen> {
  final tripID;
  _StudentTripListScreenState(this.tripID);

  List<dynamic> _studenttriplist = [];
  bool _error = false;
  bool _loading = true;

  loadStudentTripListList() async {
    setState(() {
      _studenttriplist = [];
      _loading = true;
    });
    final params = '?trip_id=' + tripID.toString();
    await http
        .get(
            Uri.parse(baseURL() + '/api/studenttrips/trip' + params.toString()))
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
    setState(() {
      _loading = false;
    });
  }

  checkOn(studenttripID) async {
    final storage = new FlutterSecureStorage();
    var user = await storage.read(key: 'user');

    if (user != null) {
      final params = {
        'studenttrip_id': studenttripID.toString(),
        'carer_id': jsonDecode(user)['id'].toString(),
      };
      await http
          .patch(Uri.parse(baseURL() + '/api/checkOnStudentTrip'), body: params)
          .then((response) {
        if (response.statusCode == 200) {
          successSnackBar(context, 'Xác nhận học sinh lên xe');
          loadStudentTripListList();
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

  checkOff(studenttripID) async {
    final storage = new FlutterSecureStorage();
    var user = await storage.read(key: 'user');

    if (user != null) {
      final params = {
        'studenttrip_id': studenttripID.toString(),
        'carer_id': jsonDecode(user)['id'].toString(),
      };
      await http
          .patch(Uri.parse(baseURL() + '/api/checkOffStudentTrip'),
              body: params)
          .then((response) {
        if (response.statusCode == 200) {
          successSnackBar(context, 'Xác nhận học sinh xuống xe');
          loadStudentTripListList();
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

  checkAbsence(studenttripID) async {
    final storage = new FlutterSecureStorage();
    var user = await storage.read(key: 'user');

    if (user != null) {
      final params = {
        'studenttrip_id': studenttripID.toString(),
        'carer_id': jsonDecode(user)['id'].toString(),
      };
      await http
          .patch(Uri.parse(baseURL() + '/api/checkAbsenceStudentTrip'),
              body: params)
          .then((response) {
        if (response.statusCode == 200) {
          successSnackBar(context, 'Xác nhận học sinh nghỉ');
          loadStudentTripListList();
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
    loadStudentTripListList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Học sinh tham gia chuyến',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                                                _studenttriplist[index]
                                                    ['student']['student_name'],
                                                style: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                'Lên xe: ' +
                                                    _studenttriplist[index]
                                                            ['on_at']
                                                        .toString(),
                                                style: TextStyle(fontSize: 19)),
                                            Text(
                                                'Xuống xe: ' +
                                                    _studenttriplist[index]
                                                            ['off_at']
                                                        .toString(),
                                                style: TextStyle(fontSize: 19)),
                                            _studenttriplist[index]
                                                        ['absence'] ==
                                                    1
                                                ? Text('Đã vắng',
                                                    style: TextStyle(
                                                        fontSize: 19,
                                                        color:
                                                            Colors.pinkAccent))
                                                : Text(''),
                                            _studenttriplist[index]
                                                        ['absence_req'] ==
                                                    1
                                                ? Text('Có phép nghỉ',
                                                    style: TextStyle(
                                                        fontSize: 19,
                                                        color: Colors.green))
                                                : Text(''),
                                            Wrap(children: [
                                              MaterialButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => MapScreen(
                                                            stop: jsonEncode(
                                                                _studenttriplist[
                                                                        index]
                                                                    ['stop']))),
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
                                              _studenttriplist[index]
                                                          ['on_at'] ==
                                                      null
                                                  ? MaterialButton(
                                                      onPressed: () {
                                                        checkOn(_studenttriplist[
                                                                index]
                                                            ['studenttrip_id']);
                                                      },
                                                      textColor: Colors.white,
                                                      child: Wrap(children: [
                                                        Icon(Icons
                                                            .login_outlined),
                                                        Text(
                                                            ' Điểm danh lên xe',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 19))
                                                      ]),
                                                      color: Colors.green,
                                                    )
                                                  : MaterialButton(
                                                      onPressed: () {
                                                        checkOff(_studenttriplist[
                                                                index]
                                                            ['studenttrip_id']);
                                                      },
                                                      textColor: Colors.white,
                                                      child: Wrap(children: [
                                                        Icon(Icons
                                                            .logout_outlined),
                                                        Text(
                                                            ' Điểm danh xuống xe',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 19))
                                                      ]),
                                                      color:
                                                          Colors.orangeAccent,
                                                    ),
                                              MaterialButton(
                                                onPressed: () {
                                                  checkAbsence(
                                                      _studenttriplist[index]
                                                          ['studenttrip_id']);
                                                },
                                                textColor: Colors.white,
                                                child: Wrap(children: [
                                                  Icon(Icons
                                                      .no_backpack_outlined),
                                                  Text(' Xác nhận vắng',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 19))
                                                ]),
                                                color: Colors.pinkAccent,
                                              )
                                            ])
                                          ],
                                        )));
                              }))
            ],
          )),
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;

import 'package:admin_app/Screens/studentbond.dart';

class StudentScreen extends StatefulWidget {
  var studentID;
  StudentScreen({Key? key, @required this.studentID}) : super(key: key);
  @override
  _StudentScreenState createState() => _StudentScreenState(studentID);
}

class _StudentScreenState extends State<StudentScreen> {
  final studentID;
  _StudentScreenState(this.studentID);
  bool _loading = true;
  bool _error = false;

  var student = null;

  loadStudent() async {
    setState(() {
      _loading = true;
    });
    final params = {'student_id': studentID};
    await http
        .get(Uri.http(baseURL(), "/api/student", params))
        .then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData != null)
          setState(() {
            student = jsonData;
          });
      } else {
        setState(() {
          _error = true;
        });
      }
    }).catchError((e) {
      setState(() {
        _error = true;
      });
    });
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadStudent();
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Thông tin học sinh',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(20.0),
              child: _error
                  ? const Text('Có lỗi dữ liệu')
                  : _loading
                      ? Center(child: CircularProgressIndicator())
                      : student == null
                          ? Text('')
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  student != null
                                      ? Row(children: [
                                          Text('MSHS: ',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.orangeAccent)),
                                          Text(
                                              student['student_id'].toString() +
                                                  ' ',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black)),
                                          Text('Tên: ',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.orangeAccent)),
                                          Text(
                                              student['student_name']
                                                      .toString() +
                                                  ' ',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black)),
                                          Text('Lớp: ',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.orangeAccent)),
                                          Text(
                                              student['class']['class_name']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black)),
                                        ])
                                      : Text(''),
                                  student['parent'] == null
                                      ? Row(children: [
                                          Text('Chưa có phụ huynh',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.grey)),
                                          MaterialButton(
                                            color: Colors.blueAccent,
                                            textColor: Colors.white,
                                            child: Text('Chọn phụ huynh'),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        StudentBondScreen(
                                                          studentID: studentID,
                                                        )),
                                              ).then((value) {
                                                loadStudent();
                                              });
                                            },
                                          )
                                        ])
                                      : Row(children: [
                                          Text('Phụ huynh: ',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.orangeAccent)),
                                          Text(
                                              student['parent']['id']
                                                      .toString() +
                                                  ' - ' +
                                                  student['parent']['name']
                                                      .toString() +
                                                  ' ',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black)),
                                          MaterialButton(
                                            color: Colors.green,
                                            textColor: Colors.white,
                                            child: Text('Đổi phụ huynh'),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        StudentBondScreen(
                                                          studentID: studentID,
                                                        )),
                                              ).then((value) {
                                                loadStudent();
                                              });
                                            },
                                          )
                                        ]),
                                  DataTable(
                                      columns: const <DataColumn>[
                                        DataColumn(
                                          label: Expanded(
                                            child: Text(
                                              'Tên chuyến',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Text(
                                              'Giờ lên xe',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Text(
                                              'Giờ xuống xe',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Text(
                                              'Vắng',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Expanded(
                                            child: Text(
                                              'Phép',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: List<DataRow>.generate(
                                          student['studenttrip'].length,
                                          (index) => DataRow(cells: [
                                                DataCell(Text(
                                                    student['studenttrip']
                                                                [index]['trip']
                                                            ['trip_name']
                                                        .toString())),
                                                DataCell(Text(
                                                    student['studenttrip']
                                                            [index]['on_at']
                                                        .toString())),
                                                DataCell(Text(
                                                    student['studenttrip']
                                                            [index]['off_at']
                                                        .toString())),
                                                DataCell(Text(
                                                    student['studenttrip']
                                                            [index]['absence']
                                                        .toString())),
                                                DataCell(Text(
                                                    student['studenttrip']
                                                                [index]
                                                            ['absence_req']
                                                        .toString())),
                                              ])))
                                ]))),
    );
  }
}

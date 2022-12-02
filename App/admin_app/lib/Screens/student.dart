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
  var _student_info = null;
  var _parent_info = null;
  List<dynamic> _classes = [];
  int _type = 0;

  loadStudent() async {
    setState(() {
      _student_info = null;
    });
    final params = {'student_id': studentID};
    await http
        .get(Uri.http(baseURL(), "/api/student", params))
        .then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          _student_info = jsonData;
          _parent_info = jsonData['parent'];
        });
      } else {
        setState(() {
          _student_info = null;
        });
      }
    }).catchError((e) {
      setState(() {
        _student_info = null;
      });
    });
    setState(() {
      _loading = false;
    });
  }

  // loadStudentTrips() async {
  //   setState(() {
  //     _classes = [];
  //     _loading = true;
  //   });
  //   await http.get(Uri.http(baseURL(), "/api/classes")).then((response) {
  //     if (response.statusCode == 200) {
  //       var jsonData = jsonDecode(response.body);
  //       setState(() {
  //         _student_info = jsonData;
  //       });
  //     } else
  //       setState(() {
  //         _error = true;
  //       });
  //   }).catchError((e) {
  //     setState(() {
  //       _error = false;
  //     });
  //   });
  //   setState(() {
  //     _loading = false;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // loadStudentTrips();
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
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            TextButton(
                onPressed: () {
                  loadStudent();
                },
                child: Icon(Icons.refresh)),
            _student_info != null
                ? Row(children: [
                    Text('MSHS: ',
                        style: TextStyle(
                            fontSize: 17, color: Colors.orangeAccent)),
                    Text(_student_info['student_id'].toString() + ' ',
                        style: TextStyle(fontSize: 17, color: Colors.black)),
                    Text('Tên: ',
                        style: TextStyle(
                            fontSize: 17, color: Colors.orangeAccent)),
                    Text(_student_info['student_name'].toString() + ' ',
                        style: TextStyle(fontSize: 17, color: Colors.black)),
                    Text('Lớp: ',
                        style: TextStyle(
                            fontSize: 17, color: Colors.orangeAccent)),
                    Text(_student_info['class']['class_name'].toString(),
                        style: TextStyle(fontSize: 17, color: Colors.black)),
                  ])
                : Text(''),
            _parent_info == null
                ? Row(children: [
                    Text('Chưa có phụ huynh',
                        style: TextStyle(fontSize: 17, color: Colors.black)),
                    TextButton(
                      child: Text('Chọn phụ huynh'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentBondScreen(
                                    studentID: studentID,
                                  )),
                        );
                      },
                    )
                  ])
                : Row(children: [
                    Text('Phụ huynh: ',
                        style: TextStyle(
                            fontSize: 17, color: Colors.orangeAccent)),
                    Text(
                        _student_info['parent']['id'].toString() +
                            ' - ' +
                            _student_info['parent']['name'].toString(),
                        style: TextStyle(fontSize: 17, color: Colors.black)),
                  ])
            // Wrap(children: [
            //   TextButton(
            //       onPressed: () {
            //         loadStudentTrips();
            //       },
            //       child: Icon(Icons.refresh)),
            // ]),
            // _error
            //     ? const Text('Có lỗi server')
            //     : _loading
            //         ? Center(child: CircularProgressIndicator())
            //         : DataTable(
            //             columns: const <DataColumn>[
            //                 DataColumn(
            //                   label: Expanded(
            //                     child: Text(
            //                       'ID',
            //                       style: TextStyle(fontStyle: FontStyle.italic),
            //                     ),
            //                   ),
            //                 ),
            //                 DataColumn(
            //                   label: Expanded(
            //                     child: Text(
            //                       'Tên lớp',
            //                       style: TextStyle(fontStyle: FontStyle.italic),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             rows: List<DataRow>.generate(
            //                 _classes.length,
            //                 (index) => DataRow(cells: [
            //                       DataCell(Text(
            //                           _classes[index]['class_id'].toString())),
            //                       DataCell(Text(_classes[index]['class_name']
            //                           .toString())),
            //                     ])))
          ])),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;

import 'package:admin_app/Screens/studentnew.dart';
import 'package:admin_app/Screens/classlist.dart';
import 'package:admin_app/rounded_button.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({Key? key}) : super(key: key);

  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  bool _loading = true;
  bool _error = false;
  List<dynamic> _students = [];
  String _student_name = '';
  List<dynamic> _classes = [];
  String _class_id = '';

  int _type = 0;

  loadStudentList() async {
    setState(() {
      _students = [];
      _loading = true;
    });
    final params = {'student_name': _student_name};
    await http
        .get(Uri.http(baseURL(), "/api/students/name", params))
        .then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          _students = jsonData;
        });
      } else
        setState(() {
          _error = true;
        });
    }).catchError((e) {
      setState(() {
        _error = false;
      });
    });
    setState(() {
      _loading = false;
    });
  }

  loadStudentListbyClass() async {
    setState(() {
      _students = [];
      _loading = true;
    });
    final params = {'class_id': _class_id};
    await http
        .get(Uri.http(baseURL(), "/api/students/class", params))
        .then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          _students = jsonData;
        });
      } else
        setState(() {
          _error = true;
        });
    }).catchError((e) {
      setState(() {
        _error = false;
      });
    });
    setState(() {
      _loading = false;
    });
  }

  loadClassforStudent() async {
    setState(() {
      _classes = [];
    });
    await http.get(Uri.http(baseURL(), "/api/classes")).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          _classes = jsonData;
          _class_id = _classes[0]['class_id'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadStudentList();
    loadClassforStudent();
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            RoundedButton(
                btnText: 'Xem danh sách lớp',
                onBtnPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClassListScreen()));
                }),
            Wrap(children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Nhập tên',
                ),
                onChanged: (value) {
                  _student_name = value;
                },
              ),
              TextButton(
                  onPressed: () {
                    loadStudentList();
                  },
                  child: Text('Tìm theo tên')),
            ]),
            Row(children: [
              TextButton(
                  onPressed: () {
                    loadStudentListbyClass();
                  },
                  child: Text('Tìm theo lớp')),
              DropdownButton(
                  items: _classes.map((valueItem) {
                    return DropdownMenuItem(
                        value: valueItem['class_id'],
                        child: Text(valueItem['class_name']));
                  }).toList(),
                  value: _class_id,
                  onChanged: (newValue) {
                    setState(() {
                      _class_id = newValue.toString();
                    });
                  })
            ]),
            _error
                ? const Text('Có lỗi server')
                : _loading
                    ? Center(child: CircularProgressIndicator())
                    : DataTable(
                        columns: const <DataColumn>[
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'ID',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Tên',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Lớp',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('')),
                          ],
                        rows: List<DataRow>.generate(
                            _students.length,
                            (index) => DataRow(cells: [
                                  DataCell(Text(_students[index]['student_id']
                                      .toString())),
                                  DataCell(Text(_students[index]['student_name']
                                      .toString())),
                                  DataCell(Text(_students[index]['class']
                                          ['class_name']
                                      .toString())),
                                  DataCell(TextButton(
                                      child: Icon(Icons.info),
                                      onPressed: () {
                                        setState(() {
                                          _type++;
                                        });
                                      })),
                                  DataCell(TextButton(
                                      child: Icon(Icons.edit),
                                      onPressed: () {
                                        setState(() {
                                          _type++;
                                        });
                                      })),
                                  DataCell(TextButton(
                                      child: Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          _type++;
                                        });
                                      }))
                                ])))
          ])),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewStudentScreen()),
            );
          },
          label: Text('Thêm'),
          icon: Icon(Icons.add)),
    );
  }
}

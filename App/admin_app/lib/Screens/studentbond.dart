import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;

class StudentBondScreen extends StatefulWidget {
  var studentID;
  StudentBondScreen({Key? key, @required this.studentID}) : super(key: key);

  @override
  _StudentBondScreenState createState() => _StudentBondScreenState(studentID);
}

class _StudentBondScreenState extends State<StudentBondScreen> {
  final studentID;
  _StudentBondScreenState(this.studentID);

  bool _loading = true;
  bool _error = false;
  List<dynamic> _users = [];
  String _name = '';
  int _type = 0;

  loadParentList() async {
    setState(() {
      _users = [];
      _loading = true;
    });
    final params = {'type': '3', 'name': _name};
    await http
        .get(Uri.http(baseURL(), "/api/users/type", params))
        .then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          _users = jsonData;
        });
      } else {
        setState(() {
          _error = true;
        });
      }
    }).catchError((e) {
      setState(() {
        _error = false;
      });
    });
    setState(() {
      _loading = false;
    });
  }

  bondParentStudentList(int parentID) async {
    final params = {'student_id': studentID, 'parent_id': parentID.toString()};
    print(params);
    await http
        .patch(Uri.http(baseURL(), "/api/bondParentStudent", params))
        .then((response) {
      if (response.statusCode == 200) {
        successSnackBar(context, 'Thêm liên kết thành công');
        Navigator.pop(context, true);
      } else if (response.statusCode == 430) {
        errorSnackBar(context, jsonDecode(response.body).values.first);
      } else {
        errorSnackBar(context, 'Thêm mới thất bại');
      }
    }).catchError((e) {
      setState(() {
        errorSnackBar(context, 'Thêm mới thất bại');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadParentList();
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Thêm liên kết học sinh phụ huynh',
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
            Wrap(children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Nhập tên',
                ),
                onChanged: (value) {
                  _name = value;
                },
              ),
              TextButton(
                  onPressed: () {
                    loadParentList();
                  },
                  child: Text('Tìm')),
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
                                  'Email',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Điện thoại',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(label: Text(''))
                          ],
                        rows: List<DataRow>.generate(
                            _users.length,
                            (index) => DataRow(cells: [
                                  DataCell(
                                      Text(_users[index]['id'].toString())),
                                  DataCell(
                                      Text(_users[index]['name'].toString())),
                                  DataCell(
                                      Text(_users[index]['email'].toString())),
                                  DataCell(
                                      Text(_users[index]['phone'].toString())),
                                  DataCell(TextButton(
                                      child: Icon(Icons.add),
                                      onPressed: () {
                                        bondParentStudentList(
                                            _users[index]['id']);
                                      }))
                                ])))
          ])),
    );
  }
}

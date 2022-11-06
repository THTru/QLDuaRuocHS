import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:admin_app/rounded_button.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({Key? key}) : super(key: key);

  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  bool _loading = true;
  bool _error = true;
  List<dynamic> _students = [];

  loadStudentList() async {
    final params = {'student_name': ''};
    await http
        .get(Uri.http(baseURL(), "/api/students/name", params))
        .then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData.isNotEmpty) {
          setState(() {
            _students = jsonData;
            _error = false;
          });
        }
      }
    }).catchError((error) {
      // errorSnackBar(context, 'Có lỗi Server');
      setState(() {
        _error = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadStudentList();
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Danh sách học sinh',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              Text('Nhập tên ở đây nè'),
              Center(
                  child: _error
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _students.length,
                          itemBuilder: ((context, index) {
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 10.0,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(_students[index]['student_id']
                                            .toString()),
                                        Text(_students[index]['student_name']),
                                        Text(_students[index]['class']
                                            ['class_name']),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                        ))
            ]))

        /*body: _error
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _students.length,
                itemBuilder: ((context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 10.0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_students[index]['student_id'].toString()),
                              Text(_students[index]['student_name']),
                              Text(_students[index]['class']['class_name']),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
              )*/
        );
  }
}

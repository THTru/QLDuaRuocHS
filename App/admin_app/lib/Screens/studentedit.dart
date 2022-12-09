import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:admin_app/rounded_button.dart';

class EditStudentScreen extends StatefulWidget {
  var studentID;
  EditStudentScreen({Key? key, @required this.studentID}) : super(key: key);

  @override
  _EditStudentScreenState createState() => _EditStudentScreenState(studentID);
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final studentID;
  _EditStudentScreenState(this.studentID);
  bool _error = false;
  bool _loading = true;
  var student = null;

  String _student_name = '';
  String _class_id = '0';
  List<dynamic> _classes = [];
  List templist = [
    {'class_id': '0', 'class_name': 'Không có'}
  ];

  loadStudentdata() async {
    setState(() {
      _loading = true;
    });
    final params = {'student_id': studentID.toString()};
    await http
        .get(Uri.http(baseURL(), "/api/student", params))
        .then((response) {
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData != null) {
          setState(() {
            student = jsonData;
            _student_name = jsonData['student_name'];
            _class_id = jsonData['class_id'];
          });
        }
      } else
        setState(() {
          _error = true;
        });
    }).catchError((error) {
      setState(() {
        _error = true;
      });
    });
    setState(() {
      _loading = false;
    });
  }

  editStudent() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    final params = {
      'student_id': studentID.toString(),
      'student_name': _student_name,
      'class_id': _class_id,
    };
    await http
        .patch(Uri.http(baseURL(), "/api/editStudent", params),
            headers: headerswithToken(token))
        .then((response) {
      if (response.statusCode == 200) {
        successSnackBar(context, 'Chỉnh sửa thành công');
        Navigator.pop(context, true);
      } else if (response.statusCode == 430) {
        errorSnackBar(context, jsonDecode(response.body).values.first);
      } else {
        errorSnackBar(context, 'Lỗi server');
      }
    }).catchError((e) {
      setState(() {
        errorSnackBar(context, 'Lỗi server');
      });
    });
  }

  loadClassforEditStudent() async {
    setState(() {
      _classes = templist;
      _class_id = _classes[0]['class_id'];
    });
    await http.get(Uri.http(baseURL(), "/api/classes")).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData.isNotEmpty) {
          setState(() {
            _classes = jsonData;
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadClassforEditStudent();
    loadStudentdata();
  }

  @override
  Widget build(BuildContext) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Sửa thông tin học sinh',
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
                                    Wrap(children: [
                                      TextField(
                                        controller: TextEditingController(
                                            text: _student_name),
                                        decoration: const InputDecoration(
                                          hintText: 'Nhập tên*',
                                        ),
                                        onChanged: (value) {
                                          _student_name = value;
                                        },
                                      ),
                                      Row(children: [
                                        Text('Lớp:',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.orangeAccent)),
                                        DropdownButton(
                                            items: _classes.map((valueItem) {
                                              return DropdownMenuItem(
                                                  value: valueItem['class_id'],
                                                  child: Text(
                                                      valueItem['class_name']
                                                          .toString()));
                                            }).toList(),
                                            value: _class_id,
                                            onChanged: (newValue) {
                                              setState(() {
                                                _class_id = newValue.toString();
                                              });
                                            })
                                      ]),
                                      MaterialButton(
                                          onPressed: () {
                                            editStudent();
                                          },
                                          color: Colors.blueAccent,
                                          textColor: Colors.white,
                                          child: Text('Chỉnh sửa')),
                                    ]),
                                  ]))),
      ),
      RoundedButton(
          btnText: '⬅',
          onBtnPressed: () {
            Navigator.pop(context, true);
          })
    ]);
  }
}

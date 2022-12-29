import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:admin_app/rounded_button.dart';

class NewStudentScreen extends StatefulWidget {
  const NewStudentScreen({Key? key}) : super(key: key);

  @override
  _NewStudentScreenState createState() => _NewStudentScreenState();
}

class _NewStudentScreenState extends State<NewStudentScreen> {
  String _student_id = '';
  String _student_name = '';
  String _class_id = '';
  List<dynamic> _classes = [];
  List templist = [
    {'class_id': '0', 'class_name': 'Không có'}
  ];

  newStudent() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    final params = {
      'student_id': _student_id,
      'student_name': _student_name,
      'class_id': _class_id,
    };
    await http
        .post(Uri.http(baseURL(), "/api/newStudent", params),
            headers: headerswithToken(token))
        .then((response) {
      if (response.statusCode == 200) {
        successSnackBar(context, 'Thêm mới thành công');
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

  loadClassforNewStudent() async {
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
            _class_id = _classes[0]['class_id'];
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadClassforNewStudent();
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
            'Thêm học sinh',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(children: [
                        TextField(
                          decoration: const InputDecoration(
                            hintText: 'Nhập ID*',
                          ),
                          onChanged: (value) {
                            _student_id = value;
                          },
                        ),
                        TextField(
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
                                  fontSize: 17, color: Colors.orangeAccent)),
                          DropdownButton(
                              items: _classes.map((valueItem) {
                                return DropdownMenuItem(
                                    value: valueItem['class_id'],
                                    child: Text(
                                        valueItem['class_name'].toString()));
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
                              newStudent();
                            },
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            child: Text('Thêm mới')),
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

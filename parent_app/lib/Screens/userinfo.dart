import 'dart:convert';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parent_app/Screens/reglist.dart';
import 'package:parent_app/rounded_button.dart';
import 'package:parent_app/General/general.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:parent_app/Screens/linereg.dart';
import 'package:parent_app/Screens/reglist.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final storage = new FlutterSecureStorage();
  List<dynamic> _studentlist = [];
  bool _error = false;
  bool _loading = true;
  int _parent_id = 0;
  String _parent_name = '';
  String _parent_phone = '';

  String _student_name = '';

  loadStudentList() async {
    setState(() {
      _studentlist = [];
      _loading = true;
    });

    var user = await storage.read(key: 'user');
    var student = await storage.read(key: 'student');
    if (user != null) {
      setState(() {
        _parent_id = jsonDecode(user)['id'];
        _parent_name = jsonDecode(user)['name'].toString();
        _parent_phone = jsonDecode(user)['phone'].toString();
      });
    }
    if (student != null) {
      setState(() {
        _student_name = jsonDecode(student)['student_name'].toString();
      });
    }

    final params = '?parent_id=' + _parent_id.toString();
    await http
        .get(Uri.parse(baseURL() + '/api/students/parent' + params.toString()))
        .then((response) {
      if (response.statusCode == 200) {
        setState(() {
          final jsonData = jsonDecode(response.body);
          _studentlist = jsonData;
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

  chooseStudent(chosenStudent) async {
    await storage.write(key: 'student', value: jsonEncode(chosenStudent));
    _student_name = chosenStudent['student_name'];
  }

  @override
  void initState() {
    super.initState();
    loadStudentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Thông tin tài khoản',
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
              Text('User: ' + _parent_name,
                  style: TextStyle(fontSize: 20, color: Colors.pinkAccent)),
              Text('Đang chọn bé: ' + _student_name,
                  style: TextStyle(fontSize: 20)),
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
                              itemCount: _studentlist.length,
                              itemBuilder: (context, index) {
                                return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: Colors.pinkAccent,
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
                                                _studentlist[index]
                                                    ['student_name'],
                                                style: TextStyle(
                                                    color: Colors.pink,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                'MSHS: ' +
                                                    _studentlist[index]
                                                            ['student_id']
                                                        .toString(),
                                                style: TextStyle(fontSize: 19)),
                                            Text(
                                                'Lớp: ' +
                                                    _studentlist[index]['class']
                                                            ['class_name']
                                                        .toString(),
                                                style: TextStyle(fontSize: 19)),
                                            MaterialButton(
                                              onPressed: () {
                                                setState(() {
                                                  chooseStudent(
                                                      _studentlist[index]);
                                                });
                                              },
                                              textColor: Colors.white,
                                              child: Wrap(children: [
                                                Icon(Icons.ads_click),
                                                Text(' Chọn',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 19))
                                              ]),
                                              color: Colors.pinkAccent,
                                            )
                                          ],
                                        )));
                              }))
            ],
          )),
    );
  }
}

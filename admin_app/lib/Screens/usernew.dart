import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:admin_app/rounded_button.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({Key? key}) : super(key: key);

  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  String _name = '';
  String _email = '';
  String _password = '';
  String _phone = '';
  int _type = 2;

  List type_list = [
    {'tag': 'Admin', 'value': 1},
    {'tag': 'Bảo mẫu', 'value': 2},
    {'tag': 'Phụ huynh', 'value': 3},
  ];

  newUser() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    final params = {
      'name': _name,
      'email': _email,
      'password': _password,
      'type': _type.toString(),
      'phone': _phone,
    };
    await http
        .post(Uri.http(baseURL(), "/api/newUser", params),
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
            'Thêm người dùng',
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
                            hintText: 'Nhập tên*',
                          ),
                          onChanged: (value) {
                            _name = value;
                          },
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            hintText: 'Nhập email*',
                          ),
                          onChanged: (value) {
                            _email = value;
                          },
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            hintText: 'Nhập password (>6 ký tự)*',
                          ),
                          onChanged: (value) {
                            _password = value;
                          },
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            hintText: 'Số điện thoại',
                          ),
                          onChanged: (value) {
                            _phone = value;
                          },
                        ),
                        Row(children: [
                          Text('Loại:',
                              style: TextStyle(
                                  fontSize: 17, color: Colors.orangeAccent)),
                          DropdownButton(
                              items: type_list.map((valueItem) {
                                return DropdownMenuItem(
                                    value: valueItem['value'],
                                    child: Text(valueItem['tag'].toString()));
                              }).toList(),
                              value: _type,
                              onChanged: (newValue) {
                                setState(() {
                                  _type = int.tryParse(newValue.toString())!;
                                });
                              })
                        ]),
                        MaterialButton(
                            onPressed: () {
                              newUser();
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

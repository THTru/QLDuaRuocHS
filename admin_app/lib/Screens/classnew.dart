import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:admin_app/rounded_button.dart';

class NewClassScreen extends StatefulWidget {
  const NewClassScreen({Key? key}) : super(key: key);

  @override
  _NewClassScreenState createState() => _NewClassScreenState();
}

class _NewClassScreenState extends State<NewClassScreen> {
  String _class_id = '';
  String _class_name = '';

  newClass() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    final params = {
      'class_id': _class_id,
      'class_name': _class_name,
    };
    await http
        .post(Uri.http(baseURL(), "/api/newClass", params),
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
            'Thêm lớp',
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
                            hintText: 'Nhập ID lớp*',
                          ),
                          onChanged: (value) {
                            _class_id = value;
                          },
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            hintText: 'Nhập tên lớp*',
                          ),
                          onChanged: (value) {
                            _class_name = value;
                          },
                        ),
                        MaterialButton(
                            onPressed: () {
                              newClass();
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
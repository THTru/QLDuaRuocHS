import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:admin_app/rounded_button.dart';

class NewDriverScreen extends StatefulWidget {
  const NewDriverScreen({Key? key}) : super(key: key);

  @override
  _NewDriverScreenState createState() => _NewDriverScreenState();
}

class _NewDriverScreenState extends State<NewDriverScreen> {
  String _driver_name = '';
  String _driver_phone = '';
  String _driver_address = '';

  newDriver() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    final params = {
      'driver_name': _driver_name,
      'driver_phone': _driver_phone,
      'driver_address': _driver_address
    };
    await http
        .post(Uri.http(baseURL(), "/api/newDriver", params),
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
            'Thêm tài xế',
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
                    hintText: 'Nhập tên*',
                  ),
                  onChanged: (value) {
                    _driver_name = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Nhập số điện thoại*',
                  ),
                  onChanged: (value) {
                    _driver_phone = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Nhập địa chỉ*',
                  ),
                  onChanged: (value) {
                    _driver_address = value;
                  },
                ),
                MaterialButton(
                    onPressed: () {
                      newDriver();
                    },
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    child: Text('Thêm mới')),
              ]),
            ])),
      ),
      RoundedButton(
          btnText: '⬅',
          onBtnPressed: () {
            Navigator.pop(context, true);
          })
    ]);
  }
}

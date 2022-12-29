import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;
import 'package:admin_app/rounded_button.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChangePWUserScreen extends StatefulWidget {
  var userID;
  ChangePWUserScreen({Key? key, @required this.userID}) : super(key: key);

  @override
  _ChangePWUserScreenState createState() => _ChangePWUserScreenState(userID);
}

class _ChangePWUserScreenState extends State<ChangePWUserScreen> {
  final userID;
  _ChangePWUserScreenState(this.userID);
  String _password = '';

  changePW() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    final params = {
      'id': userID.toString(),
      'password': _password,
    };
    await http
        .patch(Uri.http(baseURL(), "/api/changePassword", params),
            headers: headerswithToken(token))
        .then((response) {
      if (response.statusCode == 200) {
        successSnackBar(context, 'Đổi mật khẩu thành công');
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
            'Đổi mật khẩu người dùng',
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
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Nhập mật khẩu mới >=6 ký tự*',
                        ),
                        onChanged: (value) {
                          _password = value;
                        },
                      ),
                      MaterialButton(
                          onPressed: () {
                            changePW();
                          },
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          child: Text('Đổi mật khẩu')),
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

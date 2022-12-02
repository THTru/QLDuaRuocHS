import 'dart:convert';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parent_app/Screens/login.dart';
import 'package:parent_app/rounded_button.dart';
import 'package:parent_app/General/general.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:parent_app/Screens/login.dart';
import 'package:parent_app/Screens/linelist.dart';
import 'package:parent_app/Screens/userinfo.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  goToListLinePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LineListScreen()),
    );
  }

  logoutPressed() async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token != null) {
      final headers = {"Authorization": "Bearer $token"};
      await http
          .post(Uri.parse(baseURL() + '/api/logout2'), headers: headers)
          .then((response) async {
        var jsonData = jsonDecode(response.body);
        if (response.statusCode == 200) {
          successSnackBar(context, 'Đăng xuất thành công');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else {
          errorSnackBar(context, 'Có lỗi xảy ra 1');
        }
      }).catchError((error) {
        errorSnackBar(context, 'Có lỗi xảy ra 2');
      });
    } else {
      errorSnackBar(context, 'Có lỗi xảy ra 3');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Cùng con tới trường',
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
                Card(
                    margin: EdgeInsets.all(50),
                    child: Transform.scale(
                        scale: 5,
                        child: Icon(
                          Icons.airport_shuttle,
                          color: Colors.greenAccent,
                        ))),
                FractionallySizedBox(
                    widthFactor: 1,
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserInfoScreen()),
                          );
                        },
                        child: Card(
                            margin: EdgeInsets.all(5.0),
                            color: Colors.pinkAccent,
                            child: Padding(
                                padding: EdgeInsets.all(30),
                                child: Wrap(
                                  children: [
                                    Icon(Icons.account_box,
                                        color: Colors.white),
                                    Text(' Thông tin tài khoản',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 22)),
                                  ],
                                ))))),
                FractionallySizedBox(
                    widthFactor: 1,
                    child: Card(
                        margin: EdgeInsets.all(5.0),
                        color: Colors.blueAccent,
                        child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Wrap(
                              children: [
                                Icon(Icons.calendar_month, color: Colors.white),
                                Text(' Xem lịch trình của con',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 22)),
                              ],
                            )))),
                FractionallySizedBox(
                    widthFactor: 1,
                    child: InkWell(
                        onTap: () {
                          goToListLinePage();
                        },
                        child: Card(
                            margin: EdgeInsets.all(5.0),
                            color: Colors.orangeAccent,
                            child: Padding(
                                padding: EdgeInsets.all(30),
                                child: Wrap(
                                  children: [
                                    Icon(Icons.list, color: Colors.white),
                                    Text(' Đăng ký tuyến xe cho con',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 22))
                                  ],
                                ))))),
                FractionallySizedBox(
                    widthFactor: 1,
                    child: InkWell(
                        onTap: () {
                          logoutPressed();
                        },
                        child: Card(
                            margin: EdgeInsets.all(5.0),
                            color: Colors.greenAccent,
                            child: Padding(
                                padding: EdgeInsets.all(30),
                                child: Wrap(
                                  children: [
                                    Icon(Icons.logout, color: Colors.white),
                                    Text(' Đăng xuất',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 22))
                                  ],
                                )))))
              ],
            )));
  }
}

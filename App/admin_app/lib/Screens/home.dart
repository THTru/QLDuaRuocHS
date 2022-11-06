import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:admin_app/rounded_button.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;
import 'package:admin_app/Screens/userlist.dart';
import 'package:admin_app/Screens/studentlist.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  goToUserList() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const UserListScreen(),
        ));
  }

  goToStudentList() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const StudentListScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Trang chủ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Material(
                        color: Colors.orange,
                        elevation: 5,
                        child: MaterialButton(
                          minWidth: 250,
                          height: 60,
                          onPressed: () {
                            // errorSnackBar(context, 'Người dùng');
                            goToUserList();
                          },
                          child: Text(
                            "Người dùng",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        )),
                    Material(
                        color: Colors.orange,
                        elevation: 5,
                        child: MaterialButton(
                          minWidth: 250,
                          height: 60,
                          onPressed: () {
                            goToStudentList();
                          },
                          child: Text(
                            "Học sinh",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        )),
                    Material(
                        color: Colors.orange,
                        elevation: 5,
                        child: MaterialButton(
                          minWidth: 250,
                          height: 60,
                          onPressed: () {
                            errorSnackBar(context, 'Xe & tài xế');
                          },
                          child: Text(
                            "Xe & tài xế",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        )),
                    Material(
                        color: Colors.orange,
                        elevation: 5,
                        child: MaterialButton(
                          minWidth: 250,
                          height: 60,
                          onPressed: () {
                            errorSnackBar(context, 'Lịch trình');
                          },
                          child: Text(
                            "Lịch trình",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            )));
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/rounded_button.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  bool _loading = false;
  bool _error = false;
  List<dynamic> _users = [];

  loadUserList() async {
    setState(() {
      _loading = true;
    });
    final params = {'student_name': ''};
    await http
        .get(Uri.http(baseURL(), "/api/students/name", params))
        .then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData.isNotEmpty) {
          setState(() {
            _users = jsonData;
            _loading = false;
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

  callerror() {
    errorSnackBar(context, 'Có lỗi Server');
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Danh sách người dùng',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _users.isNotEmpty
          ? ListView.builder(
              itemCount: _users.length,
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
                            Text(_users[index]['student_id'].toString()),
                            Text(_users[index]['student_name']),
                            Text(_users[index]['class']['class_name']),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
            )
          : Center(
              child: _loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      child: const Text("fetch users"),
                      onPressed: loadUserList,
                    ),
            ),
    );
  }
}

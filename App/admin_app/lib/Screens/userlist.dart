import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;

import 'package:admin_app/Screens/usernew.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  bool _loading = true;
  bool _error = false;
  List<dynamic> _users = [];
  int _type = 0;
  String _name = '';

  loadUserList() async {
    setState(() {
      _users = [];
      _loading = true;
    });
    final params = {'type': _type.toString(), 'name': _name};
    await http
        .get(Uri.http(baseURL(), "/api/users/type", params))
        .then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          _users = jsonData;
        });
      } else
        setState(() {
          _error = true;
        });
    }).catchError((e) {
      setState(() {
        _error = false;
      });
    });
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserList();
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Wrap(children: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      _type = 0;
                    });
                    loadUserList();
                  },
                  child: Text('Tất cả')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _type = 1;
                    });
                    loadUserList();
                  },
                  child: Text('Admin')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _type = 2;
                    });
                    loadUserList();
                  },
                  child: Text('Bảo mẫu')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _type = 3;
                    });
                    loadUserList();
                  },
                  child: Text('Phụ huynh')),
            ]),
            Wrap(children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Nhập tên',
                ),
                onChanged: (value) {
                  _name = value;
                },
              ),
              TextButton(
                  onPressed: () {
                    loadUserList();
                  },
                  child: Text('Tìm')),
            ]),
            _error
                ? const Text('Có lỗi server')
                : _loading
                    ? Center(child: CircularProgressIndicator())
                    : DataTable(
                        columns: const <DataColumn>[
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'ID',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Tên',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Email',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Điện thoại',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Loại',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('')),
                          ],
                        rows: List<DataRow>.generate(
                            _users.length,
                            (index) => DataRow(cells: [
                                  DataCell(
                                      Text(_users[index]['id'].toString())),
                                  DataCell(
                                      Text(_users[index]['name'].toString())),
                                  DataCell(
                                      Text(_users[index]['email'].toString())),
                                  DataCell(
                                      Text(_users[index]['phone'].toString())),
                                  DataCell(int.parse(_users[index]['type']) == 1
                                      ? const Text('Admin')
                                      : int.parse(_users[index]['type']) == 2
                                          ? const Text('Bảo mẫu')
                                          : int.parse(_users[index]['type']) ==
                                                  3
                                              ? const Text('Phụ huynh')
                                              : const Text('Không xác định')),
                                  DataCell(TextButton(
                                      child: Icon(Icons.edit),
                                      onPressed: () {
                                        setState(() {
                                          _type++;
                                        });
                                      })),
                                  DataCell(TextButton(
                                      child: Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          _type++;
                                        });
                                      }))
                                ])))
          ])),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewUserScreen()),
            ).then((value) {
              loadUserList();
            });
          },
          label: Text('Thêm'),
          icon: Icon(Icons.add)),
    );
  }
}

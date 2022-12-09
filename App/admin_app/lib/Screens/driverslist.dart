import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;

import 'package:admin_app/Screens/drivernew.dart';
import 'package:admin_app/Screens/driveredit.dart';

class DriverListScreen extends StatefulWidget {
  const DriverListScreen({Key? key}) : super(key: key);

  @override
  _DriverListScreenState createState() => _DriverListScreenState();
}

class _DriverListScreenState extends State<DriverListScreen> {
  bool _loading = true;
  bool _error = false;
  List<dynamic> _drivers = [];
  String _driver_name = '';
  int _type = 0;

  loadDriverList() async {
    setState(() {
      _drivers = [];
      _loading = true;
    });
    final params = {'driver_name': _driver_name};
    await http
        .get(Uri.http(baseURL(), "/api/drivers/name", params))
        .then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          _drivers = jsonData;
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
    loadDriverList();
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
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Nhập tên',
                ),
                onChanged: (value) {
                  _driver_name = value;
                },
              ),
              TextButton(
                  onPressed: () {
                    loadDriverList();
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
                                  'Điện thoại',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Địa chỉ',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('')),
                          ],
                        rows: List<DataRow>.generate(
                            _drivers.length,
                            (index) => DataRow(cells: [
                                  DataCell(Text(
                                      _drivers[index]['driver_id'].toString())),
                                  DataCell(Text(_drivers[index]['driver_name']
                                      .toString())),
                                  DataCell(Text(_drivers[index]['driver_phone']
                                      .toString())),
                                  DataCell(Text(_drivers[index]
                                          ['driver_address']
                                      .toString())),
                                  DataCell(TextButton(
                                      child: Icon(Icons.edit),
                                      onPressed: () {
                                        setState(() {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditDriverScreen(
                                                      driverID: _drivers[index]
                                                          ['driver_id'],
                                                    )),
                                          ).then((value) {
                                            loadDriverList();
                                          });
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
              MaterialPageRoute(builder: (context) => NewDriverScreen()),
            ).then((value) {
              loadDriverList();
            });
          },
          label: Text('Thêm'),
          icon: Icon(Icons.add)),
    );
  }
}

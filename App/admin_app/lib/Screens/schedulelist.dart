import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;

import 'package:admin_app/Screens/schedulenew.dart';
import 'package:admin_app/Screens/scheduleedit.dart';
import 'package:admin_app/Screens/stoplist.dart';
import 'package:admin_app/rounded_button.dart';

class ScheduleListScreen extends StatefulWidget {
  const ScheduleListScreen({Key? key}) : super(key: key);

  @override
  _ScheduleListScreenState createState() => _ScheduleListScreenState();
}

class _ScheduleListScreenState extends State<ScheduleListScreen> {
  bool _loading = true;
  bool _error = false;
  List<dynamic> _schedules = [];
  String _schedule_name = '';
  int _type = 0;

  loadSchedueList() async {
    setState(() {
      _schedules = [];
      _loading = true;
    });
    final params = {'_schedule': _schedule_name};
    await http
        .get(Uri.http(baseURL(), "/api/schedules/name", params))
        .then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          _schedules = jsonData;
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
    loadSchedueList();
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            RoundedButton(
                btnText: 'Quản lý điểm dừng',
                onBtnPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StopListScreen()),
                  ).then((value) {
                    loadSchedueList();
                  });
                }),
            Wrap(children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Nhập tên',
                ),
                onChanged: (value) {
                  _schedule_name = value;
                },
              ),
              TextButton(
                  onPressed: () {
                    loadSchedueList();
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
                                  'Mô tả',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('')),
                          ],
                        rows: List<DataRow>.generate(
                            _schedules.length,
                            (index) => DataRow(cells: [
                                  DataCell(Text(_schedules[index]['schedule_id']
                                      .toString())),
                                  DataCell(Text(_schedules[index]
                                          ['schedule_name']
                                      .toString())),
                                  DataCell(Text(_schedules[index]
                                          ['schedule_des']
                                      .toString())),
                                  DataCell(TextButton(
                                      child: Icon(Icons.info),
                                      onPressed: () {
                                        setState(() {
                                          _type++;
                                        });
                                      })),
                                  DataCell(TextButton(
                                      child: Icon(Icons.edit),
                                      onPressed: () {
                                        setState(() {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditScheduleScreen(
                                                        scheduleID: _schedules[
                                                                index]
                                                            ['schedule_id'])),
                                          ).then((value) {
                                            loadSchedueList();
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
              MaterialPageRoute(builder: (context) => NewScheduleScreen()),
            ).then((value) {
              loadSchedueList();
            });
          },
          label: Text('Thêm'),
          icon: Icon(Icons.add)),
    );
  }
}

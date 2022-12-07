import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:admin_app/Screens/linenew.dart';

class LineListScreen extends StatefulWidget {
  const LineListScreen({Key? key}) : super(key: key);

  @override
  _LineListScreenState createState() => _LineListScreenState();
}

class _LineListScreenState extends State<LineListScreen> {
  bool _loading = true;
  bool _error = false;
  List<dynamic> _lines = [];
  int _linetype_id = -1;
  int _line_status = -1;
  int _type = 0;

  loadLineList() async {
    setState(() {
      _lines = [];
      _loading = true;
    });
    final params = {
      'date': '-1',
      'carer_id': '-1',
      'driver_id': '-1',
      'vehicle_id': '-1',
      'linetype_id': _linetype_id.toString(),
      'line_status': _line_status.toString()
    };
    await http
        .get(Uri.http(baseURL(), "/api/lines/filter", params))
        .then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          _lines = jsonData;
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
    loadLineList();
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Stack(children: [
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        _line_status = -1;
                      });
                      loadLineList();
                    },
                    child: Text('Tất cả')),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _line_status = 0;
                      });
                      loadLineList();
                    },
                    child: Text('Chưa công bố')),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _line_status = 1;
                      });
                      loadLineList();
                    },
                    child: Text('Đang công bố')),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _line_status = 4;
                      });
                      loadLineList();
                    },
                    child: Text('Chờ duyệt')),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _line_status = 2;
                      });
                      loadLineList();
                    },
                    child: Text('Đã duyệt')),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _line_status = 3;
                      });
                      loadLineList();
                    },
                    child: Text('Đã hủy')),
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
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Tên',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Ngày đầu',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Ngày cuối',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              DataColumn(label: Text('')),
                              DataColumn(label: Text('')),
                              DataColumn(label: Text('')),
                            ],
                          rows: List<DataRow>.generate(
                              _lines.length,
                              (index) => DataRow(cells: [
                                    DataCell(Text(
                                        _lines[index]['line_id'].toString())),
                                    DataCell(Text(
                                        _lines[index]['line_name'].toString())),
                                    DataCell(Text(
                                        dMY(_lines[index]['first_date'])
                                            .toString())),
                                    DataCell(
                                        Text(dMY(_lines[index]['last_date']))),
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
            ]),
      ])),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewLineScreen()),
            ).then((value) {
              loadLineList();
            });
          },
          label: Text('Thêm'),
          icon: Icon(Icons.add)),
    );
  }
}

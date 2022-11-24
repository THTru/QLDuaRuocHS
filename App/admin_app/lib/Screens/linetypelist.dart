import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;

import 'package:admin_app/login.dart';

class LineTypeListScreen extends StatefulWidget {
  const LineTypeListScreen({Key? key}) : super(key: key);

  @override
  _LineTypeListScreenState createState() => _LineTypeListScreenState();
}

class _LineTypeListScreenState extends State<LineTypeListScreen> {
  bool _loading = true;
  bool _error = false;
  List<dynamic> _linetypes = [];
  int _is_back = -1;
  int _shift = -1;
  int _type = 0;

  loadLineTypeList() async {
    setState(() {
      _linetypes = [];
      _loading = true;
    });
    final params = {'is_back': _is_back.toString(), 'shift': _shift.toString()};
    await http
        .get(Uri.http(baseURL(), "/api/linetypes/filter", params))
        .then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          _linetypes = jsonData;
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
    loadLineTypeList();
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
                      _is_back = -1;
                    });
                    loadLineTypeList();
                  },
                  child: Text('Tất cả')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _is_back = 0;
                    });
                    loadLineTypeList();
                  },
                  child: Text('Đi')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _is_back = 1;
                    });
                    loadLineTypeList();
                  },
                  child: Text('Về')),
            ]),
            Wrap(children: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      _shift = -1;
                    });
                    loadLineTypeList();
                  },
                  child: Text('Tất cả',
                      style: TextStyle(color: Colors.orangeAccent))),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _shift = 0;
                    });
                    loadLineTypeList();
                  },
                  child: Text('Sáng',
                      style: TextStyle(color: Colors.orangeAccent))),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _shift = 1;
                    });
                    loadLineTypeList();
                  },
                  child: Text('Chiều',
                      style: TextStyle(color: Colors.orangeAccent))),
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
                                  'Bắt đầu',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Kết thúc',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('')),
                          ],
                        rows: List<DataRow>.generate(
                            _linetypes.length,
                            (index) => DataRow(cells: [
                                  DataCell(Text(_linetypes[index]['linetype_id']
                                      .toString())),
                                  DataCell(Text(_linetypes[index]
                                          ['linetype_name']
                                      .toString())),
                                  DataCell(Text(_linetypes[index]['time_start']
                                      .toString())),
                                  DataCell(Text(_linetypes[index]['time_end']
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
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          label: Text('Thêm'),
          icon: Icon(Icons.add)),
    );
  }
}

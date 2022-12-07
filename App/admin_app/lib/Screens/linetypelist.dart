import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;

import 'package:admin_app/Screens/linetypenew.dart';

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
  List isback_list = [
    {'tag': 'Tất cả', 'value': -1},
    {'tag': 'Đi', 'value': 0},
    {'tag': 'Về', 'value': 1},
  ];
  List shift_list = [
    {'tag': 'Tất cả', 'value': -1},
    {'tag': 'Sáng', 'value': 0},
    {'tag': 'Chiều', 'value': 1},
  ];
  var valueChoose = null;

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
          child: Stack(children: [
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text('Loại:',
                    style: TextStyle(fontSize: 17, color: Colors.orangeAccent)),
                DropdownButton(
                    items: isback_list.map((valueItem) {
                      return DropdownMenuItem(
                          value: valueItem['value'],
                          child: Text(valueItem['tag'].toString()));
                    }).toList(),
                    value: _is_back,
                    onChanged: (newValue) {
                      setState(() {
                        _is_back = int.tryParse(newValue.toString())!;
                      });
                    })
              ]),
              Row(children: [
                Text('Buổi:',
                    style: TextStyle(fontSize: 17, color: Colors.orangeAccent)),
                DropdownButton(
                    items: shift_list.map((valueItem) {
                      return DropdownMenuItem(
                          value: valueItem['value'],
                          child: Text(valueItem['tag'].toString()));
                    }).toList(),
                    value: _shift,
                    onChanged: (newValue) {
                      setState(() {
                        _shift = int.tryParse(newValue.toString())!;
                      });
                    })
              ]),
              TextButton(
                  onPressed: () {
                    loadLineTypeList();
                  },
                  child: Text('Tìm')),
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
                                    'Bắt đầu',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Kết thúc',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'T2',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'T3',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'T4',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'T5',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'T6',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'T7',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'CN',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              DataColumn(label: Text('')),
                              DataColumn(label: Text('')),
                            ],
                          rows: List<DataRow>.generate(
                              _linetypes.length,
                              (index) => DataRow(cells: [
                                    DataCell(Text(_linetypes[index]
                                            ['linetype_id']
                                        .toString())),
                                    DataCell(Text(_linetypes[index]
                                            ['linetype_name']
                                        .toString())),
                                    DataCell(Text(_linetypes[index]
                                            ['time_start']
                                        .toString())),
                                    DataCell(Text(_linetypes[index]['time_end']
                                        .toString())),
                                    DataCell(_linetypes[index]['mon'] == 1
                                        ? Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          )
                                        : Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          )),
                                    DataCell(_linetypes[index]['tue'] == 1
                                        ? Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          )
                                        : Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          )),
                                    DataCell(_linetypes[index]['wed'] == 1
                                        ? Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          )
                                        : Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          )),
                                    DataCell(_linetypes[index]['thu'] == 1
                                        ? Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          )
                                        : Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          )),
                                    DataCell(_linetypes[index]['fri'] == 1
                                        ? Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          )
                                        : Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          )),
                                    DataCell(_linetypes[index]['sat'] == 1
                                        ? Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          )
                                        : Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          )),
                                    DataCell(_linetypes[index]['sun'] == 1
                                        ? Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          )
                                        : Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          )),
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
              MaterialPageRoute(builder: (context) => NewLineTypeScreen()),
            ).then((value) {
              loadLineTypeList();
            });
          },
          label: Text('Thêm'),
          icon: Icon(Icons.add)),
    );
  }
}

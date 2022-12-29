import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;

class LineRegListScreen extends StatefulWidget {
  var lineID;
  LineRegListScreen({Key? key, @required this.lineID}) : super(key: key);

  @override
  _LineRegListScreenState createState() => _LineRegListScreenState(lineID);
}

class _LineRegListScreenState extends State<LineRegListScreen> {
  final lineID;
  _LineRegListScreenState(this.lineID);

  bool _loading = true;
  bool _error = false;
  List<dynamic> _reglist = [];

  loadRegList() async {
    setState(() {
      _loading = true;
    });
    final params = {'line_id': lineID.toString()};
    await http
        .get(Uri.http(baseURL(), "/api/registrations/line", params))
        .then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          _reglist = jsonData;
        });
      } else
        setState(() {
          _error = true;
        });
    }).catchError((e) {
      setState(() {
        _error = true;
      });
    });
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadRegList();
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Danh sách đăng ký',
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
                    _error
                        ? const Text('Có lỗi server')
                        : _loading
                            ? Center(child: CircularProgressIndicator())
                            : DataTable(
                                columns: const <DataColumn>[
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Học sinh',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Điểm dừng',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                          'Thời gian đăng ký',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ),
                                  ],
                                rows: List<DataRow>.generate(
                                    _reglist.length,
                                    (index) => DataRow(cells: [
                                          DataCell(Text(_reglist[index]
                                                  ['student']['student_id'] +
                                              ' - ' +
                                              _reglist[index]['student']
                                                  ['student_name'])),
                                          DataCell(Text(_reglist[index]['stop']
                                              ['location'])),
                                          DataCell(Text(_reglist[index]
                                                  ['reg_time']
                                              .toString())),
                                        ])))
                  ]))),
    );
  }
}

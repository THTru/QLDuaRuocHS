import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;

import 'package:admin_app/Screens/dayoffnew.dart';
import 'package:admin_app/Screens/dayoffedit.dart';

class DayOffListScreen extends StatefulWidget {
  const DayOffListScreen({Key? key}) : super(key: key);

  @override
  _DayOffListScreenState createState() => _DayOffListScreenState();
}

class _DayOffListScreenState extends State<DayOffListScreen> {
  bool _loading = true;
  bool _error = false;
  List<dynamic> _dayoffs = [];
  int _type = 0;

  loadDayOffList() async {
    setState(() {
      _dayoffs = [];
      _loading = true;
    });
    await http.get(Uri.http(baseURL(), "/api/dayoffs")).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          _dayoffs = jsonData;
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
    loadDayOffList();
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      body: SingleChildScrollView(
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
                                  'Ngày',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Ghi chú',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('')),
                          ],
                        rows: List<DataRow>.generate(
                            _dayoffs.length,
                            (index) => DataRow(cells: [
                                  DataCell(Text(
                                      dMY(_dayoffs[index]['date'].toString()))),
                                  DataCell(
                                      Text(_dayoffs[index]['name'].toString())),
                                  DataCell(TextButton(
                                      child: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditDayOffScreen(
                                                      dayoffID: _dayoffs[index]
                                                          ['id'])),
                                        ).then((value) {
                                          loadDayOffList();
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
              MaterialPageRoute(builder: (context) => NewDayOffScreen()),
            ).then((value) {
              loadDayOffList();
            });
          },
          label: Text('Thêm'),
          icon: Icon(Icons.add)),
    );
  }
}

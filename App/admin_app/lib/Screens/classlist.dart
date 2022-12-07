import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;

import 'package:admin_app/Screens/classnew.dart';

class ClassListScreen extends StatefulWidget {
  const ClassListScreen({Key? key}) : super(key: key);

  @override
  _ClassListScreenState createState() => _ClassListScreenState();
}

class _ClassListScreenState extends State<ClassListScreen> {
  bool _loading = true;
  bool _error = false;
  List<dynamic> _classes = [];
  int _type = 0;

  loadClassList() async {
    setState(() {
      _classes = [];
      _loading = true;
    });
    await http.get(Uri.http(baseURL(), "/api/classes")).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          _classes = jsonData;
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
    loadClassList();
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Danh sách lớp',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
                                  'ID',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Tên lớp',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('')),
                          ],
                        rows: List<DataRow>.generate(
                            _classes.length,
                            (index) => DataRow(cells: [
                                  DataCell(Text(
                                      _classes[index]['class_id'].toString())),
                                  DataCell(Text(_classes[index]['class_name']
                                      .toString())),
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
              MaterialPageRoute(builder: (context) => NewClassScreen()),
            ).then((value) {
              loadClassList();
            });
          },
          label: Text('Thêm'),
          icon: Icon(Icons.add)),
    );
  }
}

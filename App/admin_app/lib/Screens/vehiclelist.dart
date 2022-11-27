import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;

import 'package:admin_app/Screens/vehiclenew.dart';

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({Key? key}) : super(key: key);

  @override
  _VehicleListScreenState createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  bool _loading = true;
  bool _error = false;
  List<dynamic> _vehicles = [];
  String _vehicle_no = '';
  int _type = 0;

  loadVehicleList() async {
    setState(() {
      _vehicles = [];
      _loading = true;
    });
    final params = {'vehicle_no': _vehicle_no};
    await http
        .get(Uri.http(baseURL(), "/api/vehicles/number", params))
        .then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          _vehicles = jsonData;
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
    loadVehicleList();
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
                  hintText: 'Nhập biển số',
                ),
                onChanged: (value) {
                  _vehicle_no = value;
                },
              ),
              TextButton(
                  onPressed: () {
                    loadVehicleList();
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
                                  'Biển số',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Sức chứa',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('')),
                          ],
                        rows: List<DataRow>.generate(
                            _vehicles.length,
                            (index) => DataRow(cells: [
                                  DataCell(Text(_vehicles[index]['vehicle_id']
                                      .toString())),
                                  DataCell(Text(_vehicles[index]['vehicle_no']
                                      .toString())),
                                  DataCell(Text(
                                      _vehicles[index]['capacity'].toString())),
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
              MaterialPageRoute(builder: (context) => NewVehicleScreen()),
            );
          },
          label: Text('Thêm'),
          icon: Icon(Icons.add)),
    );
  }
}

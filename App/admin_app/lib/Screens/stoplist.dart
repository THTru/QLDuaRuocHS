import 'dart:convert';

import 'package:admin_app/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/General/general.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:admin_app/Screens/stopnew.dart';

class StopListScreen extends StatefulWidget {
  const StopListScreen({Key? key}) : super(key: key);

  @override
  _StopListScreenState createState() => _StopListScreenState();
}

class _StopListScreenState extends State<StopListScreen> {
  bool _openMap = false;
  bool _loading = true;
  bool _error = false;
  List<dynamic> _stops = [];
  String _location = '';
  List<Marker> _markers = [];
  int markerID = 0;
  int _type = 0;

  loadStopList() async {
    setState(() {
      _stops = [];
      _loading = true;
    });
    final params = {'location': _location};
    await http
        .get(Uri.http(baseURL(), "/api/stops/name", params))
        .then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          _stops = jsonData;
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
    loadStopList();
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Quản lý điểm dừng',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Stack(children: [
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Nhập điểm dừng',
                  ),
                  onChanged: (value) {
                    _location = value;
                  },
                ),
                TextButton(
                    onPressed: () {
                      loadStopList();
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
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Điểm dừng',
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
                              _stops.length,
                              (index) => DataRow(cells: [
                                    DataCell(Text(
                                        _stops[index]['stop_id'].toString())),
                                    DataCell(Text(
                                        _stops[index]['location'].toString())),
                                    DataCell(TextButton(
                                        child: Icon(Icons.map),
                                        onPressed: () {
                                          setState(() {
                                            _openMap = true;
                                            _markers = [];
                                            _markers.add(Marker(
                                                markerId: MarkerId(
                                                    markerID.toString()),
                                                infoWindow: InfoWindow(
                                                    title: _stops[index]
                                                        ['location']),
                                                position: LatLng(
                                                    _stops[index]['lat'],
                                                    _stops[index]['lng'])));
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
        _openMap
            ? Container(
                height: 500,
                width: 1200,
                child: Stack(children: [
                  GoogleMap(
                      markers: Set<Marker>.of(_markers),
                      initialCameraPosition: CameraPosition(
                          target: LatLng(10.0324476, 105.7576498), zoom: 13)),
                  RoundedButton(
                      btnText: 'Đóng',
                      onBtnPressed: () {
                        setState(() {
                          _openMap = false;
                        });
                      })
                ]))
            : Text('')
      ])),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final reloadPage = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewStopScreen()),
            );

            if (reloadPage) {
              setState(() {});
            }
          },
          label: Text('Thêm'),
          icon: Icon(Icons.add)),
    );
  }
}
